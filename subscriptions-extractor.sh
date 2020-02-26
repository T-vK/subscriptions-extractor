#!/usr/bin/env bash


main() {
    INPUT="$1"

    TMP="./tmp-$(date +%s)"
    if file "${INPUT}" | grep --quiet "Zip"; then
        rm -rf "${TMP}"
        mkdir -p "${TMP}"
        unzip -qq "${INPUT}" -d "${TMP}"
        if [ -f "${TMP}/subs.db" ]; then #skytube
            skytube_to_opml "${TMP}/subs.db"
        elif [ -f "${TMP}/newpipe.db" ]; then #newpipe
            newpipe_to_opml "${TMP}/newpipe.db"
        else
            >&2 echo "Error couldn't find a known db in the given archive!"
            exit 1
        fi
        rm -rf "${TMP}"
    elif file "${INPUT}" | grep --quiet "SQLite"; then
        if [[ "$(basename -- ${INPUT})" == "subs.db" ]]; then #skytube
            skytube_to_opml "${INPUT}"
        elif [[ "$(basename -- ${INPUT})" == "newpipe.db" ]]; then #newpipe
            newpipe_to_opml "${INPUT}"
        else
            >&2 echo "Error couldn't identify the given database by its file name (make sure to keep the original file name)!"
            exit 1
        fi
        rm -rf "${TMP}"
    else
        >&2 echo "Error unknown input format!"
        exit 1
    fi
}

newpipe_to_opml() {
    DATABASE="$1"
    
    echo '<opml version="1.1">'
    echo '    <body>'
    echo '        <outline text="YouTube Subscriptions" title="YouTube Subscriptions">'

    records=$(sqlite3 ${DATABASE} "SELECT name, url FROM subscriptions")

    while IFS= read -r record; do
        channel_name="$(echo "$record" | cut -d '|' -f1)"
        channel_url="$(echo "$record" | cut -d '|' -f2)"
        #echo "... $record ..."
        echo "            <outline text=\"${channel_name}\" title=\"${channel_name}\" type=\"rss\" xmlUrl=\"${channel_url}\" />"
    done <<< "$records"

    echo '        </outline>'
    echo '    </body>'
    echo '</opml>'
}

skytube_to_opml() {
    DATABASE="$1"
    
    echo '<opml version="1.1">'
    echo '    <body>'
    echo '        <outline text="YouTube Subscriptions" title="YouTube Subscriptions">'

    records=$(sqlite3 ${DATABASE} "SELECT Title, Channel_Id FROM subs")

    while IFS= read -r record; do
        channel_name="$(echo "$record" | cut -d '|' -f1)"
        channel_url="https://www.youtube.com/feeds/videos.xml?channel_id=$(echo "$record" | cut -d '|' -f2)"
        #echo "... $record ..."
        echo "            <outline text=\"${channel_name}\" title=\"${channel_name}\" type=\"rss\" xmlUrl=\"${channel_url}\" />"
    done <<< "$records"

    echo '        </outline>'
    echo '    </body>'
    echo '</opml>'
}

main "$@"; exit
