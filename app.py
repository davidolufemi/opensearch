import time
import logging
from datetime import datetime

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s [orders-app] %(message)s"
)

def main():
    counter = 1
    while True:
        logging.info(f"Processing order #{counter} at {datetime.utcnow().isoformat()}Z")
        counter += 1
        time.sleep(60)  # sleep for 1 minute

if __name__ == "__main__":
    main()