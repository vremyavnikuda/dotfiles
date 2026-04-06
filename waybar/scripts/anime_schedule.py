#!/usr/bin/env python3
import json
import os
import time
import urllib.request

CONFIG_PATH = os.path.expanduser("~/.config/waybar/anime_schedule.conf")

def load_config():
    cfg = {}
    if os.path.exists(CONFIG_PATH):
        with open(CONFIG_PATH, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith("#") or "=" not in line:
                    continue
                k, v = line.split("=", 1)
                cfg[k.strip()] = v.strip()
    return cfg

cfg = load_config()
user = os.environ.get("ANILIST_USER") or cfg.get("username", "").strip()
mode = (cfg.get("mode", "user").strip() or "user").lower()
limit = int(cfg.get("limit", "3"))
day_offset = int(cfg.get("days", "0"))
list_status_raw = cfg.get("list_status", "CURRENT")
list_status = [s.strip().upper() for s in list_status_raw.split(",") if s.strip()]

now = time.time()
# Local day boundaries
lt = time.localtime(now)
start_struct = time.struct_time((lt.tm_year, lt.tm_mon, lt.tm_mday, 0, 0, 0, lt.tm_wday, lt.tm_yday, lt.tm_isdst))
start = int(time.mktime(start_struct)) + day_offset * 86400
end = start + 86400

API = "https://graphql.anilist.co"
headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "User-Agent": "waybar-anime-schedule/1.0",
}

entries = []

try:
    if mode == "list":
        if not user:
            entries = []
        else:
            query = """
            query ($user: String, $status: [MediaListStatus]) {
              MediaListCollection(userName: $user, type: ANIME, status_in: $status) {
                lists {
                  entries {
                    progress
                    media {
                      title { romaji english }
                      episodes
                      siteUrl
                    }
                  }
                }
              }
            }
            """
            payload = json.dumps({"query": query, "variables": {"user": user, "status": list_status}}).encode("utf-8")
            req = urllib.request.Request(API, data=payload, headers=headers, method="POST")
            with urllib.request.urlopen(req, timeout=10) as resp:
                data = json.load(resp)
            lists = data.get("data", {}).get("MediaListCollection", {}).get("lists", [])
            for l in lists:
                for e in l.get("entries", []):
                    media = e.get("media") or {}
                    title = media.get("title", {}).get("romaji") or media.get("title", {}).get("english") or "?"
                    entries.append({
                        "title": title,
                        "progress": e.get("progress"),
                        "episodes": media.get("episodes"),
                        "url": media.get("siteUrl") or "",
                    })
    elif user and mode != "global":
        query = """
        query ($user: String) {
          MediaListCollection(userName: $user, type: ANIME, status_in: [CURRENT, PLANNING]) {
            lists {
              entries {
                media {
                  title { romaji english }
                  siteUrl
                  nextAiringEpisode { airingAt episode }
                }
              }
            }
          }
        }
        """
        payload = json.dumps({"query": query, "variables": {"user": user}}).encode("utf-8")
        req = urllib.request.Request(API, data=payload, headers=headers, method="POST")
        with urllib.request.urlopen(req, timeout=10) as resp:
            data = json.load(resp)
        lists = data.get("data", {}).get("MediaListCollection", {}).get("lists", [])
        for l in lists:
            for e in l.get("entries", []):
                media = e.get("media") or {}
                nae = media.get("nextAiringEpisode")
                if not nae:
                    continue
                airing = int(nae.get("airingAt", 0))
                if start <= airing < end:
                    title = media.get("title", {}).get("romaji") or media.get("title", {}).get("english") or "?"
                    entries.append({
                        "airing": airing,
                        "episode": nae.get("episode"),
                        "title": title,
                        "url": media.get("siteUrl") or "",
                    })
        entries.sort(key=lambda x: x["airing"])
    else:
        # Global schedule for the day
        query = """
        query ($start: Int, $end: Int, $page: Int, $perPage: Int) {
          Page(page: $page, perPage: $perPage) {
            airingSchedules(airingAt_greater: $start, airingAt_lesser: $end, sort: TIME) {
              airingAt
              episode
              media { title { romaji english } siteUrl }
            }
          }
        }
        """
        payload = json.dumps({"query": query, "variables": {"start": start, "end": end, "page": 1, "perPage": 20}}).encode("utf-8")
        req = urllib.request.Request(API, data=payload, headers=headers, method="POST")
        with urllib.request.urlopen(req, timeout=10) as resp:
            data = json.load(resp)
        sched = data.get("data", {}).get("Page", {}).get("airingSchedules", [])
        for s in sched:
            media = s.get("media") or {}
            title = media.get("title", {}).get("romaji") or media.get("title", {}).get("english") or "?"
            entries.append({
                "airing": int(s.get("airingAt", 0)),
                "episode": s.get("episode"),
                "title": title,
                "url": media.get("siteUrl") or "",
            })
        entries.sort(key=lambda x: x["airing"])
except Exception as e:
    out = {
        "text": "󰎊 AN: error",
        "class": "error",
        "tooltip": f"Anime schedule error: {e}",
    }
    print(json.dumps(out, ensure_ascii=False))
    raise SystemExit(0)

if not entries:
    if not user and mode != "global":
        out = {
            "text": "󰎊 AN: set user",
            "class": "muted",
            "tooltip": "Set ANILIST_USER env or username= in ~/.config/waybar/anime_schedule.conf",
        }
    elif mode == "list":
        out = {
            "text": "󰎊 AN: empty",
            "class": "muted",
            "tooltip": "No entries in selected list status.",
        }
    else:
        out = {
            "text": "󰎊 AN: none",
            "class": "muted",
            "tooltip": "No scheduled episodes for this day.",
        }
    print(json.dumps(out, ensure_ascii=False))
    raise SystemExit(0)

items = entries[:limit]

def fmt_time(ts):
    lt = time.localtime(ts)
    return time.strftime("%H:%M", lt)

if mode == "list":
    total = len(entries)
    text = f"󰎊 AN: {total}"
    def fmt_progress(e):
        prog = e.get("progress")
        eps = e.get("episodes")
        if prog is None:
            return ""
        if eps:
            return f"{prog}/{eps}"
        return f"{prog}"
    lines = []
    for e in entries[:20]:
        prog = fmt_progress(e)
        if prog:
            lines.append(f"{e['title']}  {prog}")
        else:
            lines.append(f"{e['title']}")
    tooltip = "\n".join(lines)
    out = {
        "text": text,
        "class": "normal",
        "tooltip": tooltip,
    }
else:
    main = items[0]
    more = len(entries) - 1
    text = f"󰎊 {fmt_time(main['airing'])} {main['title']} E{main['episode']}"
    if more > 0:
        text += f" +{more}"

    lines = [f"{fmt_time(e['airing'])}  {e['title']}  E{e['episode']}" for e in entries[:20]]
    tooltip = "\n".join(lines)
    out = {
        "text": text,
        "class": "normal",
        "tooltip": tooltip,
    }
print(json.dumps(out, ensure_ascii=False))
