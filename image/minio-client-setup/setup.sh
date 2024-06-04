#!/bin/sh

# Wait for MinIO to be ready
while ! mc alias set minio http://minio:9000 minioadmin minioadmin; do
  echo "Waiting for MinIO server..."
  sleep 5
done

# Create the bucket if it doesn't exist
if ! mc ls minio/mybucket; then
  mc mb minio/mybucket
  echo "Bucket 'mybucket' created."
else
  echo "Bucket 'mybucket' already exists."
fi
# Wait for MinIO to be ready
while ! mc alias set minio http://minio:9000 minioadmin minioadmin; do
  echo "Waiting for MinIO server..."
  sleep 5
done

# Create the bucket if it doesn't exist
if ! mc ls minio/mybucket; then
  mc mb minio/mybucket
  echo "Bucket 'mybucket' created."
else
  echo "Bucket 'mybucket' already exists."
fi

exec "$@"