# Facebook daily reports downloader
Downloads Facebook daily reports and aggregated them by month

## Usage
Add yours configs to `accounts/` folder in format:

```bash
name
client_id
client_secret
```
For example:

```bash
mygreatcompany
123456789012345
0f667e9c858ab92b436617b9bc176d6b
```

## Structure
Original unzipped reports will be in `dirty_reports/` folder.

Aggregated reports will be in `reports/` folder.

Received tokens are stored in `tokens/` and will be overwritten before every run.