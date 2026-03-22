#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'
export LC_ALL=C.UTF-8

log()  { printf '  \033[1;34m·\033[0m %s\n'  "$*" >&2; }
ok()   { printf '  \033[1;32m✓\033[0m %s\n'  "$*" >&2; }
warn() { printf '  \033[1;33m⚠\033[0m %s\n'  "$*" >&2; }
die()  { printf '  \033[1;31m✗\033[0m %s\n'  "$*" >&2; exit 1; }

usage() {
  cat <<'EOF'
Usage: eYD [OPTIONS]

  -q quality : max height in pixels         (default: 1440)
  -r fps     : preferred frames per second  (default: 60)
  -s lang    : subtitle language, or "none" (default: none)
  -f file    : source filename or full path (default: source.txt)
  -p dir     : working directory            (default: current directory)
  -m size    : max file size e.g. 10g       (default: 10g)
  -x proxy   : proxy URL
  -C browser : cookies from browser (brave|chrome|firefox|edge)
  -A num     : download attempts per URL    (default: 3)
  -R num     : yt-dlp retries per attempt   (default: 20)
  -h         : show help
EOF
  exit 0
}

check_deps() {
  command -v ffmpeg  >/dev/null 2>&1 || die "ffmpeg not found — sudo apt install ffmpeg"
  command -v yt-dlp  >/dev/null 2>&1 || die "yt-dlp not found — pipx install yt-dlp"
  command -v aria2c  >/dev/null 2>&1 || die "aria2c not found — sudo apt install aria2"

  local venv_py="$HOME/.local/share/pipx/venvs/yt-dlp/bin/python"
  if [[ -x "$venv_py" ]] && ! "$venv_py" -c "import secretstorage" 2>/dev/null; then
    log "injecting secretstorage into yt-dlp venv..."
    pipx inject yt-dlp secretstorage jeepney 2>/dev/null || warn "secretstorage inject failed"
  fi

  [[ -x "$HOME/.deno/bin/deno" ]] && export PATH="$HOME/.deno/bin:$PATH" || true

  if ! command -v deno >/dev/null 2>&1 && \
     ! command -v node >/dev/null 2>&1 && \
     ! command -v bun  >/dev/null 2>&1; then
    log "no JS runtime — installing deno..."
    command -v curl >/dev/null 2>&1 || die "curl not found; install deno manually: https://deno.land"
    curl -fsSL https://deno.land/install.sh | sh -s -- --no-modify-path 2>/dev/null \
      && export PATH="$HOME/.deno/bin:$PATH" && ok "deno installed" \
      || warn "deno install failed — YouTube n-challenge may not resolve"
  fi
}

p="$PWD"; q=1440; fps=60; s="none"; m="10g"; f=""; x=""; cookie_browser=""; attempts=3; retries=20

OPTIND=1
while getopts ":q:r:s:f:p:m:x:C:A:R:h" opt; do
  case "$opt" in
    q) q="$OPTARG" ;; r) fps="$OPTARG" ;; s) s="$OPTARG"  ;; f) f="$OPTARG" ;;
    p) p="$OPTARG" ;; m) m="$OPTARG"   ;; x) x="$OPTARG"  ;;
    C) cookie_browser="$OPTARG" ;; A) attempts="$OPTARG" ;; R) retries="$OPTARG" ;;
    h) usage ;; \?) die "unknown option: -$OPTARG" ;; :) die "missing value: -$OPTARG" ;;
  esac
done
shift $((OPTIND-1))

check_deps

src="$p/source.txt"
[[ -n "$f" ]] && { [[ "$f" == */* ]] && src="$f" || src="$p/$f"; }
[[ -f "$src" ]] || die "source not found: $src"

ok_list="$p/downloaded.txt"; fail_list="$p/failed.txt"
: >"$ok_list"; : >"$fail_list"
ensure_dir() { mkdir -p -- "$1"; }

js_rt=()
if   command -v deno >/dev/null 2>&1; then js_rt+=( --js-runtimes deno )
elif command -v node >/dev/null 2>&1; then js_rt+=( --js-runtimes node )
elif command -v bun  >/dev/null 2>&1; then js_rt+=( --js-runtimes bun )
fi

proxy_arg=()
[[ -n "$x" ]] && proxy_arg+=( "--proxy=$x" ) || true

cookie_arg=()
[[ -n "$cookie_browser" ]] && cookie_arg+=( "--cookies-from-browser=$cookie_browser" ) || true

remote_ejs=()
[[ ${#js_rt[@]} -gt 0 ]] && remote_ejs+=( --remote-components ejs:github ) || true

subtitle_args=()
if [[ "$s" != "none" && -n "$s" ]]; then
  subtitle_args=(
    --write-auto-subs
    --sub-lang "$s"
    --embed-subs
    --convert-subs srt
    --compat-options no-keep-subs
  )
fi

js_label="none"
[[ ${#js_rt[@]} -gt 0 ]] && js_label="${js_rt[1]}" || true

printf '\n\033[1m  eYD\033[0m\n'
printf '  %-12s %s\n'    "source"    "$src"
printf '  %-12s %s\n'    "output"    "$p"
printf '  %-12s %dp @ %dfps  max %s\n' "quality" "$q" "$fps" "$m"
printf '  %-12s %s\n'    "subtitles" "$s"
printf '  %-12s %s\n'    "cookies"   "${cookie_browser:-none}"
printf '  %-12s %s\n'    "proxy"     "${x:-none}"
printf '  %-12s %s\n'    "runtime"   "$js_label"
printf '  %-12s aria2c + native (dash/m3u8)\n' "downloader"
printf '  %-12s %d attempts / %d retries\n' "retry" "$attempts" "$retries"
printf '\n'

common_dl=(
  --console-title --progress
  --windows-filenames --trim-filenames 180
  --extractor-args "youtube:player_client=default"
  "${proxy_arg[@]}"
  "${cookie_arg[@]}"
  "${js_rt[@]}"
  "${remote_ejs[@]}"
  --max-filesize "$m"
  --retries "$retries"
  --fragment-retries "$retries"
  --file-access-retries "$retries"
  --retry-sleep 1
  --socket-timeout 30
  # aria2c for http/https — 16 connections per server, split into 16 chunks
  --downloader aria2c
  --downloader-args "aria2c:-x 16 -s 16 -k 1M --file-allocation=none --console-log-level=warn --summary-interval=0"
  # native downloader for dash/m3u8 fragments — aria2c cannot reassemble these
  --downloader "dash,m3u8:native"
  --concurrent-fragments 4
  --http-chunk-size 10M
  "${subtitle_args[@]}"
)

fmt="bv*[acodec=none][height<=${q}][fps>=${fps}]+ba/b[height<=${q}][fps>=${fps}]"
fmt+=" / bv*[acodec=none][height<=${q}][fps<=${fps}]+ba/b[height<=${q}][fps<=${fps}]"
fmt+=" / bv*[acodec=none][height<=${q}]+ba/b[height<=${q}]"
fmt+=" / b[height<=${q}] / b"

cleanup_subs() {
  find "$1" -maxdepth 1 -type f \( -name "*.vtt" -o -name "*.srt" -o -name "*.ass" -o -name "*.ssa" \) -delete 2>/dev/null || true
}

classify() {
  local u="$1"
  [[ "$u" =~ youtube\.com/shorts/         ]] && { echo yt_short;    return; }
  [[ "$u" =~ youtube\.com/playlist\?list= ]] && { echo yt_playlist; return; }
  [[ "$u" =~ youtube\.com/watch ]] && [[ "$u" =~ list= ]] && { echo yt_playlist; return; }
  [[ "$u" =~ youtube\.com/@[^/?]+  ]] && { echo yt_channel; return; }
  [[ "$u" =~ youtube\.com/channel/ ]] && { echo yt_channel; return; }
  [[ "$u" =~ youtube\.com/c/       ]] && { echo yt_channel; return; }
  [[ "$u" =~ youtube\.com/user/    ]] && { echo yt_channel; return; }
  [[ "$u" =~ youtube\.com/watch    ]] && { echo yt_video;   return; }
  [[ "$u" =~ youtu\.be/            ]] && { echo yt_video;   return; }
  echo other
}

_dl() {
  local url="$1" outdir="$2"; shift 2
  ensure_dir "$outdir"
  local n=1 rc
  while (( n <= attempts )); do
    rc=0
    yt-dlp "${common_dl[@]}" "$@" -- "$url" || rc=$?
    if [[ $rc -eq 0 ]]; then
      [[ "$s" != "none" ]] && cleanup_subs "$outdir" || true
      return 0
    fi
    (( n++ )) || true
    sleep 2
  done
  return 1
}

dl_video() {
  local d="$p/youtube/videos"; log "video → $d"
  _dl "$1" "$d" -f "$fmt" --merge-output-format mkv --no-playlist -i \
    -o "$d/%(title)s [%(upload_date>%Y-%m-%d)s] [%(id)s].%(ext)s"
}
dl_short() {
  local d="$p/youtube/shorts"; log "short → $d"
  _dl "$1" "$d" -f "$fmt" --merge-output-format mkv --no-playlist -i \
    -o "$d/%(title)s [%(upload_date>%Y-%m-%d)s] [%(id)s].%(ext)s"
}
dl_playlist() {
  local d="$p/youtube/playlists"; log "playlist → $d"
  _dl "$1" "$d" -f "$fmt" --merge-output-format mkv --yes-playlist -i \
    -o "$d/%(playlist)s/%(playlist_index)s - %(title)s [%(id)s].%(ext)s"
}
dl_channel() {
  local d="$p/youtube/channels"; log "channel → $d"
  _dl "$1" "$d" -f "$fmt" --merge-output-format mkv --yes-playlist -i \
    -o "$d/%(uploader)s/%(upload_date>%Y-%m-%d)s - %(title)s [%(id)s].%(ext)s"
}
dl_other() {
  local d="$p/other"; log "other → $d"
  _dl "$1" "$d" -f "bv*+ba/b / b" --merge-output-format mkv -i \
    -o "$d/%(extractor)s/%(title)s [%(id)s].%(ext)s"
}

total=0; pass=0; fail=0

while IFS= read -r url || [[ -n "$url" ]]; do
  url="${url#"${url%%[![:space:]]*}"}"; url="${url%"${url##*[![:space:]]}"}"
  [[ -z "$url" || "$url" == \#* ]] && continue
  [[ "$url" == "end" ]] && break

  kind="$(classify "$url")"
  (( total++ )) || true
  printf '  \033[1;34m·\033[0m [%s] %s\n' "$kind" "$url" >&2

  rc=0
  case "$kind" in
    yt_video)    dl_video    "$url" || rc=$? ;;
    yt_short)    dl_short    "$url" || rc=$? ;;
    yt_playlist) dl_playlist "$url" || rc=$? ;;
    yt_channel)  dl_channel  "$url" || rc=$? ;;
    other)       dl_other    "$url" || rc=$? ;;
  esac

  if [[ $rc -eq 0 ]]; then
    (( pass++ )) || true; ok "$url"
    printf '%s\n' "$url" >>"$ok_list"
  else
    (( fail++ )) || true; warn "failed: $url"
    printf '%s\n' "$url" >>"$fail_list"
  fi
done <"$src"

printf '\n  \033[1mdone\033[0m  ✓ %d  ✗ %d  total %d\n\n' "$pass" "$fail" "$total"
