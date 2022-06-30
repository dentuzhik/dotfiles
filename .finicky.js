module.exports = {
    defaultBrowser: "Browserosaurus",
    // https://github.com/johnste/finicky/wiki/Configuration#general-options
    options: {
        hideIcon: true,
    },
    rewrite: [
        {
            match: () => true, // Execute rewrite on all incoming urls to make this example easier to understand
            url({ url }) {
                const removeKeysStartingWith = ["utm_", "uta_"]; // Remove all query parameters beginning with these strings
                const removeKeys = ["fblid", "gclid"]; // Remove all query parameters matching these keys

                const search = url.search
                    .split("&")
                    .map((parameter) => parameter.split("="))
                    .filter(
                        ([key]) =>
                            !removeKeysStartingWith.some((startingWith) =>
                                key.startsWith(startingWith)
                            )
                    )
                    .filter(
                        ([key]) =>
                            !removeKeys.some((removeKey) => key === removeKey)
                    );

                return {
                    ...url,
                    search: search
                        .map((parameter) => parameter.join("="))
                        .join("&"),
                };
            },
        },
        {
            // Replace domain of urls to amazon.com with smile.amazon.com
            match: "amazon.com/*",
            url: {
                host: "smile.amazon.com",
            },
        },
    ],
    handlers: [
        {
          // Redirect all web links
          // from: https://app.slack.com/client/<team id>/<channel>
          // to: slack://channel?team=<team-id>&id=<channel-id>
          //
          // Redirect all deep linked messages
          // from: https://<subdomain>.slack.com/archives/<channel-id>/p<16-digit-timestamp>
          // to: slack://channel?team=<team-id>&id=<channel-id>&message=<10-digit-6-decimal-timestamp>
          browser: "/Applications/Slack.app",
          match: [
            '*.slack.com/client/*',
            '*.slack.com/archives/*'
          ],
          url({ url }) {
            const parts = url.pathname.split('/')
            // Return input URL if no expected path is found
            if (parts.length < 2) return url
            let team
            switch (parts[1]) {
              // For direct web links
              case 'client':
                team = parts[2]
                parts.splice(2, 1) // Remove team identifier to match archives format
                break
              // For deep links
              case 'archives':
                const org = url.host.split('.')[0]
                switch (org) {
                  case 'taxify':
                    // Starts with a T and can be found in the web app URL for any channel in your org
                    team = 'T02SA4XL8'
                    break
                  default:
                    // Return input URL if no team lookup available
                    return url
                  }
            }
            search = `team=${team}`
            let channel = parts[2]
            if (parts.length === 3) {
            // If this is a link to a channel/user
              search = `${search}&id=${channel}`
            // If this is a link to a message
            } else if (parts.length === 4) {
              const message = parts[3].slice(1, 11) + '.' + parts[3].slice(11)
              search = `${search}&channel=${channel}&message=${message}`
            }
            return {
                protocol: "slack",
                username: "",
                password: "",
                host: "channel",
                port: null,
                pathname: "",
                search: search,
                hash: ""
            }
          }
        },
        // https://github.com/johnste/finicky/wiki/Configuration-ideas#open-spotify-links-in-spotify-app
        {
            match: "open.spotify.com/*",
            browser: "Spotify",
        },
        {
            // Open Zoom links in Zoom app
            match: [
                "zoom.us/*",
                finicky.matchDomains(/.*\zoom.us/),
                /zoom.us\/j\//,
            ],
            browser: "us.zoom.xos",
        },
        {
            match: "https://www.figma.com/file/*",
            browser: "Figma",
        },
        {
            // Open apple.com and example.org urls in Safari
            match: finicky.matchHostnames([
                "localhost",
                "github.com",
                "taxify.atlassian.net",
                "bolt.zoom.us",
                "small-improvements.com",
                "taxify.slack.com",
                "docs.google.com",
                "app2.greenhouse.io",
            ]),
            browser: "Brave Browser",
        },
        {
            // Open any link clicked in Slack in Safari
            match: ({ sourceBundleIdentifier }) =>
                sourceBundleIdentifier === "com.tinyspeck.slackmacgap" ||
                sourceBundleIdentifier === "com.googlecode.iterm2",
            browser: "Brave Browser",
        },
    ],
};
