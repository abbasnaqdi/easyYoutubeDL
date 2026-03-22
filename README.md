# eYD — Easy YouTube Downloader

A smart, automated download manager built on **yt-dlp** and **aria2c**.
Supports YouTube videos, shorts, playlists, channels, and virtually any site yt-dlp supports.

[![Donate BTC](https://img.shields.io/badge/BTC-Donate-orange)](https://idpay.ir/oky2abbas)
[![Donate ETH](https://img.shields.io/badge/ETH%20%2F%20USDT-Donate-blue)](https://idpay.ir/oky2abbas)

**BTC** `1HPZyUP9EJZi2S87QrvCDrE47qRV4i5Fze`
**ETH / USDT** `0x4a4b0A26Eb31e9152653E4C08bCF10f04a0A02a9`

---

## Features

- Automatically detects URL type: video, short, playlist, channel, or any supported site
- Downloads video and audio as a single merged MKV file
- Embeds subtitles (manual or auto-generated) and cleans up temporary subtitle files
- Maximum speed via aria2c with 16 parallel connections per download
- Organizes output into categorized subdirectories
- Auto-installs missing JS runtime (deno) required for YouTube n-challenge solving
- Retries failed downloads with configurable attempts

---

## Dependencies

eYD requires **yt-dlp**, **ffmpeg**, and **aria2**. It auto-installs **deno** and **secretstorage** on first run if missing.

**Debian / Ubuntu**
```bash
sudo apt install ffmpeg aria2
pipx install yt-dlp
```

**macOS**
```bash
brew install ffmpeg aria2
pipx install yt-dlp
```

**Red Hat / Fedora**
```bash
sudo dnf install ffmpeg aria2
pipx install yt-dlp
```

**Windows** — use WSL (Ubuntu) then follow the Debian steps above.

> `pipx` is the recommended way to install yt-dlp. If you don't have it: `sudo apt install pipx && pipx ensurepath`

---

## Installation

```bash
wget https://raw.githubusercontent.com/oky2abbas/easyYoutubeDL/master/easyYoutubeDL.sh
chmod +x easyYoutubeDL.sh
```

Optionally move it somewhere on your PATH:
```bash
sudo mv easyYoutubeDL.sh /usr/local/bin/eYD
```

### Alias (recommended)

Add a short alias to your shell config (`~/.bashrc` or `~/.zshrc`):

```bash
alias eYD='bash /path/to/easyYoutubeDL.sh'
```

Or if you moved it to `/usr/local/bin/eYD`, no alias is needed — just call `eYD` directly.

Apply immediately:
```bash
source ~/.zshrc   # or source ~/.bashrc
```

---

## Usage

```
eYD [OPTIONS]

  -q quality    max height in pixels         (default: 1440)
  -r fps        preferred frames per second  (default: 60)
  -s lang       subtitle language, or "none" (default: none)
  -f file       source filename or full path (default: source.txt)
  -p dir        working / output directory   (default: current directory)
  -m size       max file size e.g. 10g       (default: 10g)
  -x proxy      proxy URL
  -C browser    cookies from browser: brave|chrome|firefox|edge
  -A num        download attempts per URL    (default: 3)
  -R num        yt-dlp retries per attempt   (default: 20)
  -h            show help
```

---

## Source File Format

Create a plain text file with one URL per line.

```
# YouTube video
https://www.youtube.com/watch?v=XXXXXXXXXXX

# YouTube Short
https://www.youtube.com/shorts/XXXXXXXXXXX

# Playlist
https://www.youtube.com/playlist?list=XXXXXXXXXXX

# Channel
https://www.youtube.com/@ChannelHandle

# Any other supported site
https://vimeo.com/XXXXXXXXXXX

end
```

- Lines starting with `#` are ignored
- The word `end` stops processing even if more lines follow
- Blank lines are skipped

---

## Examples

**1080p at 30fps, English subtitles, cookies from Brave:**
```bash
eYD -q 1080 -r 30 -s en -C brave -p ~/Downloads/ydl -f sourceY.txt
```

**1440p at 60fps, no subtitles:**
```bash
eYD -q 1440 -r 60 -p ~/Downloads -f source.txt
```

**Best quality, Persian subtitles, size limit 5g:**
```bash
eYD -q 2160 -r 60 -s fa -m 5g -p ~/Downloads -f source.txt
```

**Audio-friendly (download will still be video; use yt-dlp directly for audio-only):**
```bash
eYD -q 480 -p ~/Downloads/audio -f source.txt
```

**With proxy:**
```bash
eYD -q 1080 -r 30 -x socks5://127.0.0.1:1080 -p ~/Downloads -f source.txt
```

**Aggressive retry for unstable connections:**
```bash
eYD -q 1080 -r 30 -A 5 -R 50 -p ~/Downloads -f source.txt
```

---

## Output Structure

```
<output dir>/
├── youtube/
│   ├── videos/         ← single YouTube videos
│   ├── shorts/         ← YouTube Shorts
│   ├── playlists/      ← playlists (organized by playlist name)
│   └── channels/       ← channel downloads (organized by uploader)
├── other/              ← all other sites (organized by extractor name)
├── downloaded.txt      ← successfully downloaded URLs
└── failed.txt          ← URLs that failed all attempts
```

File naming: `Title [YYYY-MM-DD] [videoID].mkv`

---

## Cookies

Pass `-C brave` (or `chrome`, `firefox`, `edge`) to authenticate with your browser session. This is required for age-restricted videos, members-only content, or to avoid bot-check errors.

```bash
eYD -q 1080 -C brave -p ~/Downloads -f source.txt
```

> On Linux, the browser must be closed or at least not actively locking the cookie store during extraction. If cookie decryption fails, eYD automatically injects `secretstorage` into the yt-dlp environment to fix it.

---

## JavaScript Runtime

YouTube requires a JS runtime (deno, node, or bun) to solve its download URL obfuscation (n-challenge). eYD automatically installs **deno** on first run if none is found. You can also install it manually:

```bash
curl -fsSL https://deno.land/install.sh | sh
echo 'export PATH="$HOME/.deno/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

---

## Troubleshooting

**"Sign in to confirm you're not a bot"**
Pass `-C brave` (or your browser) to authenticate via cookies.

**"n challenge solving failed"**
No JS runtime is available. Let eYD auto-install deno, or install node: `sudo apt install nodejs`.

**Subtitles not embedding**
Ensure ffmpeg is installed. eYD embeds subtitles into the MKV and removes all temporary `.srt`/`.vtt` files automatically.

**Downloads are slow**
aria2c is used automatically with 16 connections. If your ISP throttles, try a proxy with `-x`.

**A URL always fails**
Check `failed.txt` for the URL, then test it manually:
```bash
yt-dlp --list-formats "https://..."
```

---

## Supported Sites

Any site supported by yt-dlp — YouTube, Vimeo, Twitter/X, Instagram, TikTok, Dailymotion, SoundCloud, and [900+ more](https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md).

---

## License

MIT
