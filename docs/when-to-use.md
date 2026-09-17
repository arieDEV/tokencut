# Kapan pakai tokencut vs main agent

## Pakai tokencut (✂️)
- Baca / ringkas **banyak atau file besar** di *project user*
- Generate boilerplate dari referensi
- Review draft/diff
- Classifier saat prompt kabur **untuk kerja coding di project**

## Jangan pakai tokencut (🧠 main)
1. **Modifikasi tokencut sendiri** — ubah script/config/README di `/workspace/tokencut`
2. **Project baru / greenfield** — scaffold app, buat repo baru, “buat aplikasi dari nol” (ikuti skill code-changes / CloudAgent)
3. **Tanya produk tokencut** — cara pakai, status toggle, penjelasan README
4. Debug bedah baris yang butuh konteks penuh di chat utama
5. Keputusan arsitektur tanpa brief worker

## Gate wajib untuk agent
Sebelum `smart-route` / `role-run` / `cmd` / `resolve-prompt`:

```bash
/workspace/tokencut/scripts/should-use-tokencut --prompt "<user ask>" [--paths ...]
```

Jika `use=false` → kerjakan di main, badge `--none`.  
Jika `use=true` → lanjut pipeline tokencut + auto-continue.
