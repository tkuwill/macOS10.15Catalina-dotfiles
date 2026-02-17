#!/bin/sh
# Description: Download music from YouTube with better file handling.

OK=0
CANCEL=1
ESC=255
DOWNLOAD_DIR="$HOME/Downloads"
TEMP_BASENAME="temp_dl_music" # 設定一個唯一的臨時檔名基礎

    while URL=$(dialog --title "Music Download" --inputbox "Please input the url of the song : " 10 70 2>&1 >/dev/tty)
    do
        result=$?
        if [ $result -eq $OK ]; then
            cd "$DOWNLOAD_DIR" || { dialog --msgbox "Error: Cannot access $DOWNLOAD_DIR" 10 50; break; }

            # 1. 使用 --output (簡寫 -o) 設定臨時檔名，並用 --print-filepath 打印最終檔名
            # 將 yt-dlp 的標準輸出 (stdout) 捕獲到 TEMP_FILE_PATH 變數中
            TEMP_FILE_PATH=$(
                dialog --title "Downloading..." --prgbox "yt-dlp is downloading... \nURL: $URL" 30 70 \
                "yt-dlp -f 'ba' -x --audio-format mp3 $URL -o \"$TEMP_BASENAME.%(ext)s\" --print-filepath" \
                2>&1 >/dev/tty
            )
            
            # 檢查下載是否成功，並確保檔案路徑被獲取
            if [ -z "$TEMP_FILE_PATH" ] || [ ! -f "$TEMP_FILE_PATH" ]; then
                dialog --msgbox "Download failed or file not found!" 10 70
                continue # 繼續迴圈，讓使用者重新輸入 URL
            fi

            # 2. 提示使用者輸入最終檔名
            while nam=$(dialog --title "Rename File" --inputbox "Download Complete.\nPlease enter the final song name (without extension): " 10 70 2>&1 >/dev/tty)
            do
                # 3. 重新命名檔案
                FINAL_NAME="$DOWNLOAD_DIR/${nam}.mp3"
                mv "$TEMP_FILE_PATH" "$FINAL_NAME"
                
                # 4. 顯示結果並退出內層迴圈
                dialog --msgbox "Successfully renamed to: ${nam}.mp3" 10 70
                break
            done

        elif [ $result -eq $CANCEL ] || [ $result -eq $ESC ]; then
            break
        fi
    done
clear