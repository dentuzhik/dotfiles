const trackingParameters = [
    "fbclid",
    "gclid",
    "dclid",
    "msclkid",
    "mc_cid",
    "mc_eid",
];

// CommonJS keeps this configuration compatible with Finicky 3 and 4. Switch to
// `export default` after every machine has upgraded to Finicky 4.
module.exports = {
    defaultBrowser: "Arc",
    rewrite: [
        {
            match: () => true,
            url: ({ url }) => {
                const searchParams = new URLSearchParams(url.search);

                for (const key of [...searchParams.keys()]) {
                    if (
                        key.startsWith("utm_") ||
                        key.startsWith("uta_") ||
                        trackingParameters.includes(key)
                    ) {
                        searchParams.delete(key);
                    }
                }

                return {
                    ...url,
                    search: searchParams.toString(),
                };
            },
        },
    ],
    handlers: [
        {
            match: "open.spotify.com/*",
            browser: "Spotify",
        },
        {
            match: "www.figma.com/*",
            browser: "Figma",
        },
    ],
};
