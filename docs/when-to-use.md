# Kapan tokencut aktif (seperti dependency terpasang)

**tokencut ON = sudah “ter-install”.** User **tidak** perlu bilang “pakai tokencut”.
Seperti `npm` / `pip`: kalau tugas coding cocok, agent **wajib** memakai tokencut sendiri.

Matikan hanya dengan: `toggle off` (global) atau kasus pengecualian di bawah.

## Aktif otomatis (✂️) — default
Setiap ask coding di **project user yang sudah ada** (bukan folder tokencut):
- Baca / ringkas / jelaskan area kode
- Generate boilerplate dari referensi
- Review draft/diff
- Debug dengan log + potongan kode
- Prompt kabur → classifier low lalu lanjut role

Alur agent (tanpa menunggu kata ajaib):

```bash
should-use-tokencut --prompt "<user ask>"
# jika use=true:
detect-project / use-for-project --prompt "..."
# lalu Task worker + drive-next (auto-continue) + badge ✂️
```

## Tetap di main (🧠) — pengecualian
1. **Modifikasi tokencut sendiri** (`/workspace/tokencut`, “ubah/perbaiki tokencut”)
2. **Project baru / greenfield** (scaffold dari nol)
3. **Tanya produk tokencut** (cara pakai, status toggle, README)
4. **tokencut di-toggle OFF**
5. Debug bedah yang memang butuh konteks penuh di chat utama

## Gate
```bash
/workspace/tokencut/scripts/should-use-tokencut --prompt "<user ask>" [--paths ...]
```
`use=false` → main + badge `--none`  
`use=true` → auto pack (user tidak perlu sebut tokencut)
