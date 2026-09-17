# Pakai tokencut untuk project apa pun (tanpa peduli path)

User cukup bilang: **"pakai tokencut"** + maksudnya.

Agent wajib:

1. `should-use-tokencut --prompt "..."` — tolak hanya meta tokencut / greenfield murni  
2. `detect-project` — cari repo di `/workspace` selain `tokencut`  
3. `use-for-project --prompt "..."` — resolve + pack  
4. Auto-continue sampai selesai + badge ✂️  

User **tidak** perlu tahu atau menulis path.
