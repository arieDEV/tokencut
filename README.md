# tokencut

**Hemat token untuk coding agent** — worker lokal di komputer agent.  
Bukan chatbot. Bukan “mode chat”. Mirip dependency (`npm` / `pip`): pasang sekali, lalu jalan sendiri.

Inspired by Spotify *shunt*, **tanpa Portal / AiKA**.

---

## Cocok untuk siapa?

| Kamu pakai… | Support? | Cara |
| --- | --- | --- |
| **Cursor** (IDE) | ✅ Ya | One-click `./scripts/install` → skills masuk `~/.cursor/skills/tokencut` |
| **Grok Bot** / agent di box (seperti agent yang bantu kamu di chat ini) | ✅ Ya | `install` memasang skill ke folder workflows agent |
| Coding agent lain yang bisa jalankan shell + worker murah | ✅ Ya | Set `TOKENCUT_ROOT` + symlinks skills |
| ChatGPT web / Claude.ai web (tanpa akses shell komputer) | ❌ Tidak | Perlu agent yang punya terminal di mesin |

**Singkat:** tokencut hidup di **komputer agent** (Cursor box / Grok Bot computer / CI), bukan di browser chat biasa.

---

## Setup one-click (otomatis ON)

Di mesin tempat agent bekerja:

```bash
git clone https://github.com/arieDEV/tokencut.git
cd tokencut
./scripts/install
```

Itu yang dilakukan install:

1. `toggle on` — tokencut aktif seperti dependency terpasang  
2. Set `TOKENCUT_ROOT` + `TOKENCUT_JOBS`  
3. Pasang skills ke **Cursor** dan/atau **Grok Bot** (kalau foldernya ada)  
4. Siap — **tidak perlu** bilang “pakai tokencut”

Cek:

```bash
./scripts/toggle status
```

Harus kelihatan **ON**.

> One-click ini **ada di repo** (`scripts/install`). Kalau README lama terasa rumit: itu yang kurang jelas, bukan fiturnya tidak ada.

---

## Cara pakai (orang awam)

1. Pasang dengan `./scripts/install` (sekali).  
2. Buka project kode yang sudah ada di komputer agent.  
3. Chat biasa ke agent, contoh:
   - “Jelaskan alur login”
   - “Review file auth ini”
   - “Buat boilerplate test dari contoh ini”
4. Kalau tokencut ikut kerja, jawaban diakhiri badge **✂️** + job id.  
5. Kalau badge **🧠** / tanpa ✂️ → agent jawab langsung (biasanya: edit tokencut sendiri, bikin project baru, atau `toggle off`).

Kamu **tidak** perlu hafal path atau perintah. Agent yang jalanin script-nya.

Matikan total:

```bash
./scripts/toggle off
```

---

## Apa yang terjadi di belakang?

```text
Kamu tanya soal kode
        ↓
Gate: cocok untuk tokencut? (bukan edit tokencut / project baru)
        ↓
Deteksi project → worker murah baca/tulis/review
        ↓
(pipeline lanjut otomatis)
        ↓
Jawaban + badge ✂️
```

Detail untuk author agent: [`docs/PUBLIC.md`](docs/PUBLIC.md)

---

## Support IDE / agent (ringkas)

| | Cursor | Grok Bot / box agent | Agent CLI lain |
| --- | :---: | :---: | :---: |
| One-click install | ✅ | ✅ | ✅ (env + skills) |
| Auto pakai tanpa kata ajaib | ✅ (via skills) | ✅ (via skills) | ✅ jika agent ikut skill |
| Badge ✂️ | ✅ | ✅ | ✅ |

---

## Perintah berguna (opsional)

Hanya kalau kamu suka CLI; sehari-hari cukup chat ke agent.

```bash
export TOKENCUT_ROOT=/path/ke/tokencut

"$TOKENCUT_ROOT/scripts/toggle" status
"$TOKENCUT_ROOT/scripts/detect-project" --json
"$TOKENCUT_ROOT/scripts/use-for-project" --prompt "Jelaskan struktur singkat"
```

---

## Syarat

- `bash`, `jq`, `python3`
- Agent yang bisa menjalankan shell di mesin yang sama dengan repo project

---

## Lisensi

MIT — lihat [`LICENSE`](LICENSE)

Release: [v1.0.0](https://github.com/arieDEV/tokencut/releases/tag/v1.0.0)

---

## Bahasa Inggris (one paragraph)

tokencut is a **local installable dependency** for coding agents (Cursor, Grok Bot, etc.). Run `./scripts/install` once; when ON it auto-routes heavy read/boilerplate/review work to cheaper workers and shows a ✂️ badge. It is not a chat mode and does not run inside browser-only chat products.
