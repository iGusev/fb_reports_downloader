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

Put downloader in a crontab:
```bash
0 */12 * * * sh ~/fb_reports_downloader/fb_downloader.sh
```
[Facebook documentation](https://developers.facebook.com/docs/payments/developer_reports_api#when):
>When to request reports

>We build new reports once per day and make them available at 8AM US Pacific Time (UTC -8/-7), so the most recent date for which reports are available is typically the day before the request.

>Payment reports will be available to download for up to 45 days.

## Structure
`fb_downloader.sh` - script for download reports.
`fb_aggregator.sh` - script for aggregate reports.

Original unzipped reports will be in `dirty_reports/` folder.

Aggregated reports will be in `reports/` folder.

Received tokens are stored in `tokens/` and will be overwritten before every run.