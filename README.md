# check-pia-vpn

- Bash shell script to check the status of PIA VPN (via API).
- Does not rely on scraping the contents of a website, and uses PIA's (private) API.
- (this may break in the future, but seems fairly stable)

## Usage

```$ ./check-pia-vpn.sh```

- exits (0) if protected by PIA
- exits >0 if not
- edit the script to control debug level


## Example (Verbose) Output

```
External IP location information:
{
  "ip": "123.123.123.123",
  "cc": "US",
  "cn": "Uniteed states",
  "cty": "New York",
  "pc": "Something",
  "lat": 3.45,
  "lng": 6.78,
  "isp": "Your ISP",
  "rgn": "Somewhere",
  "org": "More ISP"
}
Checking external IP address (123.123.12.123)... true
```
