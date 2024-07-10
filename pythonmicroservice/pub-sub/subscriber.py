from google.cloud import pubsub_v1
import os

project_id = "ica2-425321"
subscription_id = "my-topic-sub"

subscriber = pubsub_v1.SubscriberClient()
subscription_path = subscriber.subscription_path(project_id, subscription_id)

def callback(message):
    """Receives a message and acknowledges it."""
    print(f"Received message: {message.data.decode('utf-8')}")
    message.ack()

if __name__ == "__main__":
    streaming_pull_future = subscriber.subscribe(subscription_path, callback=callback)
    print(f"Listening for messages on {subscription_path}..")

    # Wrap subscriber in a 'with' block to ensure proper shutdown
    with subscriber:
        try:
            # Blocks until an exception is thrown or the process is manually interrupted
            streaming_pull_future.result()
        except KeyboardInterrupt:
            streaming_pull_future.cancel()