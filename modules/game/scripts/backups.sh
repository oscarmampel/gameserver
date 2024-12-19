#!/bin/bash

BUCKET_NAME="${bucket_name}"
FOLDER_PATH="${save_files_path}"
UPLOAD_FOLDER="save_files/${game_name}"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
TAR_FILENAME="backup_$DATE.tar.gz"
NUM_BACKUPS=5

echo "Checking if the folder exists: $FOLDER_PATH"
if [ ! -d "$FOLDER_PATH" ]; then
    echo "The folder $FOLDER_PATH does not exist. Exiting."
    exit 1
fi

echo "Compressing the folder $FOLDER_PATH into $TAR_FILENAME..."
tar -czf "$TAR_FILENAME" -C "$FOLDER_PATH" .

echo "Uploading the compressed file to Google Cloud Storage..."
gsutil cp "$TAR_FILENAME" gs://"$BUCKET_NAME"/"$UPLOAD_FOLDER"/"$TAR_FILENAME"

echo "Deleting old files in the bucket..."

FILE_COUNT=$(gsutil ls -l gs://"$BUCKET_NAME"/"$UPLOAD_FOLDER"/* | head -n -1 | wc -l)

NUM_FILES_TO_DELETE=$(($FILE_COUNT - $NUM_BACKUPS))
NUM_FILES_TO_DELETE=$(($NUM_FILES_TO_DELETE < 0 ? 0 : $NUM_FILES_TO_DELETE))

FILES_TO_DELETE=$(gsutil ls -l gs://"$BUCKET_NAME"/"$UPLOAD_FOLDER"/* | head -n -1 | sort -k 2 -r | tail -n -"$NUM_FILES_TO_DELETE" | awk '{print $3}')

for FILE in $FILES_TO_DELETE; do
    gsutil rm "$FILE"
    echo "Deleted file: $FILE"
done

echo "Deleting the local compressed file..."
rm -f "$TAR_FILENAME"
echo "Local compressed file deleted."

echo "Process completed."
