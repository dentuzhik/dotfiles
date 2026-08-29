#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
REPOSITORY_DIR="$(dirname -- "$SCRIPT_DIR")"
readonly REPOSITORY_DIR
readonly MANIFEST="$REPOSITORY_DIR/apps/installomator-apps.tsv"
readonly MANUAL_LIST="$REPOSITORY_DIR/apps/manual-apps.md"

readonly INSTALLOMATOR_VERSION="10.9"
readonly INSTALLOMATOR_PACKAGE_URL="https://github.com/Installomator/Installomator/releases/download/v10.9/Installomator-10.9.pkg"
readonly INSTALLOMATOR_PACKAGE_SHA256="8974888d6b27071cd6418d2d5afc53e39f7dff682641e7faed64d3d379679fad"
readonly INSTALLOMATOR_SCRIPT_SHA256="aeec8ee3cec401a4d1b48a7df0b8018ac4bd6d82691a65f3676fdc7272cb91b3"
readonly INSTALLOMATOR_INSTALLER_ID="JME5BW3F3R"
readonly INSTALLOMATOR_RECEIPT="com.scriptingosx.Installomator"
readonly INSTALLED_SCRIPT="/usr/local/Installomator/Installomator.sh"

WORK_DIR=""
PACKAGE=""
PACKAGE_SCRIPT=""

usage() {
    cat <<'EOF'
Usage: scripts/install-apps.sh MODE

Modes:
  --list     Show the managed and manual application inventories.
  --audit    Verify the pinned package, labels, URLs, and Apple Team IDs.
  --install  Run the audit, install the pinned package, then install/update apps.

The install mode needs macOS, an interactive terminal, network access, and sudo.
It never force-quits a running app and never replaces a Mac App Store copy.
EOF
}

die() {
    printf 'Error: %s\n' "$*" >&2
    exit 1
}

cleanup() {
    if [[ -n "$WORK_DIR" && -d "$WORK_DIR" ]]; then
        case "$WORK_DIR" in
            "${TMPDIR:-/tmp}"/dotfiles-installomator.*)
                rm -rf -- "$WORK_DIR"
                ;;
        esac
    fi
}

require_macos() {
    [[ "$(uname -s)" == "Darwin" ]] || die 'Installomator supports macOS only.'
}

create_work_dir() {
    [[ -z "$WORK_DIR" ]] || return
    WORK_DIR="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-installomator.XXXXXXXX")"
    PACKAGE="$WORK_DIR/Installomator-${INSTALLOMATOR_VERSION}.pkg"
}

download_and_verify_package() {
    local actual_hash signature

    create_work_dir
    printf 'Downloading Installomator %s...\n' "$INSTALLOMATOR_VERSION"
    curl --fail --location --proto '=https' --tlsv1.2 \
        --retry 3 --output "$PACKAGE" "$INSTALLOMATOR_PACKAGE_URL"

    actual_hash="$(shasum -a 256 "$PACKAGE" | awk '{print $1}')"
    [[ "$actual_hash" == "$INSTALLOMATOR_PACKAGE_SHA256" ]] || \
        die "Installomator package checksum mismatch: $actual_hash"

    signature="$(pkgutil --check-signature "$PACKAGE")"
    grep -Fq "Developer ID Installer: Armin Briegel ($INSTALLOMATOR_INSTALLER_ID)" \
        <<<"$signature" || die 'Installomator package has an unexpected signer.'
    grep -Fq 'Notarization: trusted by the Apple notary service' \
        <<<"$signature" || die 'Installomator package is not notarized.'
    spctl --assess --type install "$PACKAGE" || \
        die 'Gatekeeper rejected the Installomator package.'

    pkgutil --expand-full "$PACKAGE" "$WORK_DIR/expanded"
    PACKAGE_SCRIPT="$WORK_DIR/expanded/Installomator.pkg/Payload/Installomator.sh"
    [[ -f "$PACKAGE_SCRIPT" ]] || die 'Installomator script is missing from the package.'
    actual_hash="$(shasum -a 256 "$PACKAGE_SCRIPT" | awk '{print $1}')"
    [[ "$actual_hash" == "$INSTALLOMATOR_SCRIPT_SHA256" ]] || \
        die "Installomator script checksum mismatch: $actual_hash"

    printf 'Verified package checksum, notarization, signer, and script payload.\n'
}

label_team_id() {
    local label="$1"

    awk -v target="$label)" '
        {
            line = $0
            sub(/^[[:space:]]*/, "", line)
        }
        line == target { found = 1 }
        found && line ~ /^expectedTeamID=/ {
            sub(/^expectedTeamID=/, "", line)
            gsub(/"/, "", line)
            print line
            exit
        }
        found && line == ";;" { exit }
    ' "$PACKAGE_SCRIPT"
}

audit_manifest() {
    local label name expected_team_id notes packaged_team_id output resolved_name

    printf 'Auditing managed application labels...\n'
    while IFS=$'\t' read -r label name expected_team_id notes || [[ -n "$label" ]]; do
        [[ -n "$label" && "$label" != \#* ]] || continue
        [[ "$label" =~ ^[a-z0-9]+$ ]] || die "Invalid label in manifest: $label"
        [[ "$expected_team_id" =~ ^[A-Z0-9]{10}$ ]] || \
            die "Invalid Apple Team ID for $label: $expected_team_id"

        packaged_team_id="$(label_team_id "$label")"
        [[ -n "$packaged_team_id" ]] || die "Label is absent from pinned package: $label"
        [[ "$packaged_team_id" == "$expected_team_id" ]] || \
            die "Apple Team ID changed for $label: $packaged_team_id"

        if ! output="$(/bin/zsh --no-rcs "$PACKAGE_SCRIPT" "$label" \
            DEBUG=2 RETURN_LABEL_NAME=1 NOTIFY=silent 2>&1)"; then
            printf '%s\n' "$output" >&2
            die "Pinned label failed its URL audit: $label"
        fi
        resolved_name="$(printf '%s\n' "$output" | tail -n 1 | tr -d '\r')"
        [[ "$resolved_name" == "$name" ]] || \
            die "Label $label resolved as '$resolved_name', expected '$name'."
        printf '  verified %-22s %s (%s)\n' "$label" "$name" "$expected_team_id"
    done < "$MANIFEST"
}

audit() {
    require_macos
    [[ -r "$MANIFEST" ]] || die "Missing manifest: $MANIFEST"
    download_and_verify_package
    audit_manifest
    printf 'Audit passed for Installomator %s.\n' "$INSTALLOMATOR_VERSION"
}

verify_installed_script() {
    local actual_hash installed_version

    [[ -x "$INSTALLED_SCRIPT" ]] || die "Installed script is missing: $INSTALLED_SCRIPT"
    actual_hash="$(shasum -a 256 "$INSTALLED_SCRIPT" | awk '{print $1}')"
    [[ "$actual_hash" == "$INSTALLOMATOR_SCRIPT_SHA256" ]] || \
        die "Installed Installomator script checksum mismatch: $actual_hash"
    installed_version="$(pkgutil --pkg-info "$INSTALLOMATOR_RECEIPT" | \
        awk -F': ' '$1 == "version" { print $2 }')"
    [[ "$installed_version" == "$INSTALLOMATOR_VERSION" ]] || \
        die "Installed Installomator version is $installed_version, expected $INSTALLOMATOR_VERSION."
}

install_apps() {
    local label name expected_team_id notes

    [[ -t 0 && -t 1 ]] || die 'Install mode must run in an interactive terminal.'
    audit

    printf 'Installing verified Installomator package (sudo required)...\n'
    sudo /usr/sbin/installer -pkg "$PACKAGE" -target /
    verify_installed_script

    while IFS=$'\t' read -r label name expected_team_id notes || [[ -n "$label" ]]; do
        [[ -n "$label" && "$label" != \#* ]] || continue
        printf '\nInstalling or updating %s...\n' "$name"
        sudo "$INSTALLED_SCRIPT" "$label" \
            DEBUG=0 \
            BLOCKING_PROCESS_ACTION=prompt_user \
            PROMPT_TIMEOUT=300 \
            IGNORE_APP_STORE_APPS=no \
            REOPEN=no \
            NOTIFY=success \
            LOGGING=INFO
    done < "$MANIFEST"

    printf '\nManaged application pass complete. Review %s for manual installs.\n' \
        "$MANUAL_LIST"
}

list_apps() {
    local label name expected_team_id notes

    printf 'Managed by pinned Installomator %s:\n' "$INSTALLOMATOR_VERSION"
    while IFS=$'\t' read -r label name expected_team_id notes || [[ -n "$label" ]]; do
        [[ -n "$label" && "$label" != \#* ]] || continue
        printf '  %-22s %-24s %s\n' "$label" "$name" "$notes"
    done < "$MANIFEST"
    printf '\nManual-install rationale: %s\n' "$MANUAL_LIST"
}

main() {
    [[ $# -eq 1 ]] || {
        usage
        exit 2
    }

    case "$1" in
        --list) list_apps ;;
        --audit) audit ;;
        --install) install_apps ;;
        -h|--help) usage ;;
        *) usage; exit 2 ;;
    esac
}

trap cleanup EXIT
main "$@"
