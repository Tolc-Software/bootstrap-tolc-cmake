"""
Brief:               Get a particular release asset id from github
                     Returns a non-zero exit code if it doesn't find the asset id

File name:           get_release_id.py
Author:              Simon Rydell
Python Version:      3.8
"""

import requests
import argparse
import sys


def parseArguments():
    parser = argparse.ArgumentParser(
        description="Get a particular release asset id from github"
    )
    for arg, description in [
        ("--user", "Github user who owns the repository"),
        ("--repository", "Repository name to search"),
        ("--tag", "The release tag to search for, e.g. v0.1"),
        ("--asset-name", "The asset name to search for, e.g. linux-release.tar.gz"),
    ]:
        parser.add_argument(
            arg, type=str, required=True, help=description,
        )
    return parser.parse_args()


def main():
    args = parseArguments()
    url = f"https://@api.github.com/repos/{args.user}/{args.repository}/releases"
    req = requests.get(url)

    response = req.json()
    if "message" in response:
        # Github just issues a message when something goes wrong
        # Since this could be anything, just print it out and exit
        print(response)
        sys.exit(1)

    found_tag = False
    for release in response:
        if release["tag_name"] == args.tag:
            found_tag = True
            for asset in release["assets"]:
                if asset["name"] == args.asset_name:
                    print(asset["id"])
                    sys.exit()

    if not found_tag:
        print(f"Did not find the tag provided: {args.tag}", file=sys.stderr)
    else:
        print(
            f"Did not find the release asset provided: {args.asset_name}",
            file=sys.stderr,
        )

    sys.exit(1)


if __name__ == "__main__":
    main()
