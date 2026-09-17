# Rencana tokencut v2 (tanpa implementasi)

**Status:** rencana saja — belum dikerjakan  
**Tanggal:** 2026-09-18  
**Prinsip:** ambil *pola* AI Second Brain; jangan jadi second-brain/ops penuh.

## 1. Tujuan v2

Membuat tokencut tetap mesin **hemat token untuk coding**, tetapi lebih “pintar memakai diri sendiri”:

1. Tahu sedikit tentang user/tim (brain)
2. Belajar dari koreksi (learn)
3. Dipanggil lewat SOP/command singkat
4. Pipeline berat selalu ditutup synthesizer yang lebih kuat
5. Transparansi (badge/toggle) tetap wajib

Bukan tujuan v2: Slack/Docs/Jira/meeting recorder/dashboard konten.

## 2. Yang sudah ada di v1 (baseline)

| Komponen | Lokasi | Fungsi |
| --- | --- | --- |
| Role catalog | `config/roles.json` | reader / writer / reviewer / architect / debugger |
| Packer | `scripts/role-run` | Pack job + `model_hint` |
| Shortcuts | `scripts/bulk-read`, `code-write` | reader / writer |
| Pipelines | `scripts/pipeline` | draft→review, read→architect |
| Smart-route | `scripts/smart-route` + `config/router-rules.json` | Heuristik role/model |
| Badge | `scripts/badge` | ✂️ / 🧠 + tier 💚💛❤️ |
| Toggle | `scripts/toggle` + `config/settings.json` | on/off, badge, smart-route |
| Jobs | `/workspace/.tokencut/jobs/` | Prompt + manifest |

## 3. Pola Second Brain yang diadopsi

| Pola SB | Adopsi v2 | Tidak diadopsi |
| --- | --- | --- |
| Otak (`CLAUDE.md`) | `config/brain.md` (+ optional memory shard) | Profil kehidupan penuh / multi-client |
| `/learn` | `scripts/learn` → `memory/lessons.md` | Knowledge base perusahaan besar |
| Commands / SOP | `config/commands/*.md` + `scripts/cmd` | Packs voice, meetbot, dashboard |
| Fleet murah → synthesizer | Perketat pipeline + step `synthesize` wajib | Multi-provider model zoo |
| Guardrails | Policy: mutasi file butuh konfirmasi user | Hook editor generik ala Claude Code |
| Skills “tangan” | Tetap di luar tokencut (skill bot) | Drive/Slack/Calendar di dalam repo tokencut |

## 4. Arsitektur v2 (target)

```
User prompt
    │
    ▼
smart-route (heuristik, boleh baca brain.md ringkas)
    │
    ├─ role pack (low/medium/high workers)
    │     reader / writer / reviewer / debugger
    │
    ├─ optional pipeline steps…
    │
    └─ synthesizer (high)  ← baru / diperketat
            │
            ▼
     jawaban ke user + badge ✂️ (role chain + model)
```

Brain & lessons di-inject ke prompt worker **secara terbatas** (ringkas), bukan dump file besar ke chat utama.

## 5. Epik & deliverable

### Epik A — Brain (fondasi konteks)

**Deliverable**

- `config/brain.md.template` + `config/brain.md` (gitignore-able bila sensitif)
- Field yang disarankan: peran user, stack, repo penting, gaya review, bahasa, larangan
- `role-run` / `smart-route` membaca cuplikan brain (mis. max N karakter) ke `PROMPT.md`

**Acceptance**

- Tanpa brain: perilaku = v1
- Dengan brain: prompt job memuat section `## Brain (user)` yang terpotong aman
- Tidak ada kredensial di brain; ada checklist di template

**Non-goal:** CRM, multi-persona klien, sync cloud.

### Epik B — Learn (memori koreksi)

**Deliverable**

- `scripts/learn --text "..."` atau `--from-file`
- Penyimpanan: `memory/lessons.md` (append, bertanggal) + optional tag role
- Inject lessons yang relevan (keyword/tag) ke prompt role terkait

**Acceptance**

- Koreksi sekali → muncul di lesson store
- Job berikutnya untuk role yang sama membawa ≤K lesson terbaru/relevan
- `toggle` tidak menghapus lessons; ada `learn list` / `learn clear --tag`

**Non-goal:** embedding DB, rag server.

### Epik C — Commands / SOP

**Deliverable**

- `config/commands/` contoh:
  - `review-pr.md` → reader(paths) → reviewer → synthesize
  - `add-tests.md` → writer → reviewer
  - `explain-area.md` → reader → synthesizer
- `scripts/cmd <name> --paths …` merakit pipeline dari SOP

**Acceptance**

- Satu command menghasilkan job(s) + `PIPELINE.md` yang jelas
- Badge akhir menyebut command name + chain role

**Non-goal:** puluhan command PM/ops; mulai 3–5 command coding saja.

### Epik D — Synthesizer wajib untuk kerja berat

**Deliverable**

- Role baru atau mode `synthesizer` (`model_hint=high`)
- Pipeline policy: jika ada ≥2 step atau corpus > threshold → step akhir synthesize
- Synthesizer hanya menerima brief/worker outputs, bukan corpus mentah besar (reuse guard architect)

**Acceptance**

- `draft-then-review` dan `read-then-architect` punya step akhir yang merapikan untuk user
- Melanggar guard ukuran → error + saran brief

### Epik E — Smart-route v2 (tetap heuristik dulu)

**Deliverable**

- Baca sinyal dari brain (stack keywords) + lessons tags
- Output machine-readable: `suggested_command` opsional selain role
- Confidence + `ambiguous` tetap; `--pack` tetap gated

**Acceptance**

- Golden tests ditambah (10–20 prompt)
- Tidak mengklaim “AI classifier”; dokumentasi jujur: heuristik + sinyal brain

**Phase later (opsional, bukan v2 inti):** classifier worker `low` untuk prompt ambigu saja.

### Epik F — UX keagenan (badge, toggle, audit)

**Deliverable**

- Badge mendukung chain: `reader💚→reviewer💛→synth❤️`
- `toggle` tetap; tambah ` torizon learn inject on|off` bila perlu
- `scripts/last` atau status: job terakhir + apakah hemat diklaim

**Acceptance**

- User selalu bisa bedakan main vs tokencut
- Klaim hemat hanya jika ada job id + badge ✂️

## 6. Urutan pengerjaan yang disarankan

1. **A Brain** — value cepat, risiko rendah  
2. **F Badge chain** — supaya v2 terasa jelas di chat  
3. **D Synthesizer policy** — kualitas akhir  
4. **C Commands** — DX  
5. **B Learn** — compound over time  
6. **E Smart-route v2** — setelah ada brain/lessons untuk sinyal

Perkiraan effort (kasar, relatif): A &lt; F &lt; D ≈ C &lt; B &lt; E.

## 7. Risiko & mitigasi

| Risiko | Mitigasi |
| --- | --- |
| Scope creep jadi Second Brain | Gate: tidak ada konektor eksternal di repo tokencut |
| Brain/lessons membengkakkan prompt | Cap karakter + ringkas otomatis |
| Smart-route salah role | Ambiguous → tanya user; badge jujur |
| User kira worker low = model terkuat | Dokumen + badge tier wajib |
| Secrets di brain.md | Template warning + gitignore path lokal |

## 8. Definisi selesai v2 (MVP)

v2 MVP selesai bila:

1. `brain.md` opsional ter-inject ke job  
2. Minimal 3 command SOP coding  
3. Pipeline berat punya synthesizer `high`  
4. Badge mendukung multi-step  
5. Learn minimal (append + inject sederhana)  
6. README menjelaskan beda v1/v2 dan beda vs Second Brain  

## 9. Di luar v2 (backlog sadar)

- Konektor Slack/Docs/Jira  
- Meeting/voice packs  
- Dashboard HTML otomatis Mingguan  
- Router LLM penuh  
- Integrasi Portal/AiKA  

## 10. Keputusan yang perlu dari user nanti (saat implementasi)

- Isi awal `brain.md` (peran, bahasa, stack)  
- Apakah lessons boleh di-commit atau lokal saja  
- Command SOP mana yang diprioritaskan (PR review vs explain area vs add tests)  

---

*Dokumen ini rencana saja. Tidak ada fitur v2 yang diimplementasikan bersama penulisan file ini.*
