from google.cloud import pubsub_v1
import os

project_id = "ica2-425321"
topic_id = "my-topic"

publisher = pubsub_v1.PublisherClient()
topic_path = publisher.topic_path(project_id, topic_id)

def publish_message(data):
    """Publishes a message to a Pub/Sub topic."""
    # Data must be a byte string
    data = data.encode("utf-8")
    future = publisher.publish(topic_path, data)
    print(f"Published message ID: {future.result()}")

if __name__ == "__main__":
    publish_message("Hello, Pub/Sub!")