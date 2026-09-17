# tokencut

**Mesin hemat token untuk coding agent** di komputer ini.

Bukan chatbot. Bukan Second Brain ops (Slack/Docs/Jira).  
tokencut memecah kerja: file besar / boilerplate / review → worker murah atau menengah; jawaban akhir → chat utama + badge transparan.

Terinspirasi Spotify *shunt*, **tanpa Portal / AiKA**.

---

## README ini untuk apa?

Dokumen ini adalah **panduan resmi** tokencut:

1. Apa itu & kapan dipakai  
2. Cara “pasang” (sudah ada di mesin agent)  
3. Cara hidupkan / matikan  
4. Cara pakai (cepat → lengkap)  
5. Badge (biar tahu low/medium/high)  
6. Auto-continue  
7. Troubleshooting  

Rencana desain: [`docs/v2-plan.md`](docs/v2-plan.md) · Upstream Spotify: [`README.upstream.md`](README.upstream.md)

---

## Instalasi / lokasi

Di Grok Bot computer ini **sudah terpasang**:

```text
/workspace/tokencut/           ← kode + config + scripts
/workspace/.tokencut/jobs/     ← job runtime (PROMPT, manifest, jawaban)
```

Tidak perlu `npm install` untuk memakai script bash/python yang ada.  
Butuh: `bash`, `jq`, `python3` (biasanya sudah ada).

**Clone ke mesin lain (opsional):**

```bash
# salin folder /workspace/tokencut
export TOKENCUT_ROOT=/path/ke/tokencut
export TOKENCUT_JOBS=/path/ke/.tokencut/jobs
mkdir -p "$TOKENCUT_JOBS"
"$TOKENCUT_ROOT/scripts/toggle" on
```

---

## Quick start (3 menit)

```bash
# 1. Pastikan hidup
/workspace/tokencut/scripts/toggle on
/workspace/tokencut/scripts/toggle status

# 2. Isi profil singkat (opsional tapi berguna)
#    edit: /workspace/tokencut/config/brain.md

# 3. Pack + jalankan lewat agent (contoh SOP)
/workspace/tokencut/scripts/cmd explain-area \
  --question "Fungsi apa yang diekspor?" \
  --paths src/foo.ts
```

Agent lalu: `Task` worker sesuai `model_hint` → `drive-next` sampai selesai → balas dengan badge ✂️.

Atau bilang di chat: *“pakai tokencut, jelaskan file X”* — agent yang memanggil script.

---





## Project apa pun (user tidak perlu path)

Cukup bilang di chat: **“pakai tokencut, …(maksud kerja)…”**

Agent akan:

1. Cek gate (`should-use-tokencut`)
2. Deteksi project di `/workspace` (`detect-project`) — **bukan** folder tokencut
3. Pack job (`use-for-project` / `resolve-prompt`)
4. Auto-continue sampai selesai + badge

```bash
/workspace/tokencut/scripts/detect-project --json
/workspace/tokencut/scripts/use-for-project --prompt "Jelaskan alur auth singkat"
```

Kalau belum ada repo lain di `/workspace`, clone/buka project dulu — path tetap urusan agent, bukan user.

## Kapan pakai / kapan jangan

| Situasi | Mode |
| --- | --- |
| Baca file besar / boilerplate / review di **project user** | ✂️ tokencut |
| **Modifikasi tokencut** sendiri | 🧠 main |
| **Project baru** / scaffold app | 🧠 main (+ code-changes) |
| Tanya cara pakai / status tokencut | 🧠 main |

Gate:

```bash
/workspace/tokencut/scripts/should-use-tokencut --prompt "..." [--paths ...]
```

Detail: [`docs/when-to-use.md`](docs/when-to-use.md).

## On / off

```bash
/workspace/tokencut/scripts/toggle status
/workspace/tokencut/scripts/toggle on
/workspace/tokencut/scripts/toggle off              # matikan SEMUA tokencut
/workspace/tokencut/scripts/toggle auto-continue on|off
/workspace/tokencut/scripts/toggle badge on|off
/workspace/tokencut/scripts/toggle smart-route on|off
/workspace/tokencut/scripts/toggle inject-brain on|off
/workspace/tokencut/scripts/toggle inject-lessons on|off
```

State: `config/settings.json`

| Perintah | Arti |
| --- | --- |
| `toggle off` | Tokencut mati total → jawaban di chat utama (🧠) |
| `toggle auto-continue off` | Tetap bisa pack job, tapi agent tidak wajib auto-lanjut step |
| `toggle on` + `auto-continue on` | Mode normal yang disarankan |

---

## Cara pakai

### A. SOP siap pakai (`cmd`)

```bash
/workspace/tokencut/scripts/cmd --list

/workspace/tokencut/scripts/cmd explain-area \
  --question "..." --paths f1.ts f2.ts

/workspace/tokencut/scripts/cmd review-change \
  --spec "..." --reference ref.ts --target out.ts

/workspace/tokencut/scripts/cmd design-choice \
  --question "..." --paths f1.ts
```

### B. Role langsung (`role-run`)

| Role | Model | Untuk |
| --- | --- | --- |
| `reader` | low 💚 | Baca / ringkas file besar |
| `writer` | low 💚 | Boilerplate dari referensi |
| `reviewer` | medium 💛 | Kritik draft/diff |
| `debugger` | medium 💛 | Error / log / stack trace |
| `architect` | high ❤️ | Tradeoff (brief pendek) |
| `synthesizer` | high ❤️ | Gabung output worker → jawaban akhir |

```bash
/workspace/tokencut/scripts/role-run --list

/workspace/tokencut/scripts/role-run --role reader \
  --question "Apa yang dilakukan modul ini?" \
  --paths src/a.ts src/b.ts
```

Stdout = JSON job. Agent wajib `Task` executor dengan `model=<model_hint>` dan isi `prompt_file`.

### C. Prompt kabur → classifier

```bash
/workspace/tokencut/scripts/resolve-prompt \
  --prompt "Tolong bantu soal file ini" --paths f.ts
# → Task classifier (low) → simpan answer.json

/workspace/tokencut/scripts/apply-classify --job-dir <classifier_job_dir>
# → pack role terpilih → Task worker → drive-next
```

### D. Smart-route (heuristik)

```bash
/workspace/tokencut/scripts/smart-route \
  --prompt "Review draft ini" --paths a.ts --draft draft.ts --classify
```

### E. Shortcut lama

```bash
/workspace/tokencut/scripts/bulk-read --question "..." --paths ...
/workspace/tokencut/scripts/code-write --spec "..." --reference ref.ts [--target out.ts]
```

### F. Maju step & inspeksi

```bash
/workspace/tokencut/scripts/drive-next [--job-dir DIR]
/workspace/tokencut/scripts/last 3
/workspace/tokencut/scripts/e2e --question "..." --paths file.ts
```

---

## Badge (wajib terlihat)

Supaya tahu jawaban pakai tokencut atau main chat:

```bash
/workspace/tokencut/scripts/badge --from-job .../manifest.json
/workspace/tokencut/scripts/badge --chain reader:low,synthesizer:high --job-id ...
/workspace/tokencut/scripts/badge --none
```

Contoh baris akhir chat:

```text
✂️ tokencut chain 📖reader💚→🧵synthesizer❤️ · job=20260918-...
🧠 main · tanpa tokencut · model=chat-utama
```

Tanpa ✂️ + job id → **jangan klaim hemat token**.

---

## Brain & learn

```bash
# Profil user/tim (di-inject ke prompt worker)
$EDITOR /workspace/tokencut/config/brain.md
# Template: config/brain.md.template

# Simpan koreksi supaya session berikutnya ingat
/workspace/tokencut/scripts/learn add \
  --title "prefer path:line" \
  --tags reader,general \
  --text "Klaim penting harus pakai path:line"
/workspace/tokencut/scripts/learn list
```

---

## Auto-continue

Jika `auto_continue=ON`, setelah job/pipeline mulai agent **menyelesaikan semua step** tanpa menunggu “lanjut”, kecuali stop / approval destruktif / ambigu memblokir.

Lihat [`docs/auto-continue.md`](docs/auto-continue.md).

---

## Alur tipikal (agent)

```
User minta kerja coding
    → toggle status (harus ON)
    → resolve-prompt / cmd / smart-route / role-run
    → Task worker (model_hint)
    → drive-next (ulang sampai action=done)
    → balas user + badge ✂️
```

---

## Tes regresi

```bash
/workspace/tokencut/tests/smart-route-golden.sh
```

---

## Bukan untuk

- Integrasi Slack / Docs / Calendar / Jira / meeting recorder  
- Keputusan arsitektur murni tanpa brief (tetap main / architect dengan brief pendek)  
- Klaim angka hemat 90% Spotify (benchmark mereka; di sini tergantung harga worker host)

---

## Struktur folder

```text
tokencut/
  config/     roles.json, settings.json, brain.md, commands/, router-rules.json
  scripts/    CLI utama
  memory/     lessons.md
  docs/       v2-plan, auto-continue, followups
  tests/      golden smart-route
```

Jobs runtime: `/workspace/.tokencut/jobs/<id>/`
