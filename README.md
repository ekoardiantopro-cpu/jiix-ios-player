# JIIX

JIIX adalah aplikasi pemutar musik iOS bergaya streaming yang dibuat dengan SwiftUI dan AVPlayer.

## Fitur

- Beranda ala aplikasi streaming musik
- Pencarian lagu, artis, genre, dan mood
- Mini player + halaman now playing
- Playback audio streaming dari URL sample online
- Siap dibuka di Xcode sebagai project iPhone

## Cara menjalankan

1. Buka `Jiix.xcodeproj` di Xcode.
2. Pilih target `Jiix`.
3. Pada tab `Signing & Capabilities`, pilih Apple ID / Team Anda.
4. Jalankan ke Simulator iPhone atau device iPhone fisik.

## Buka di Mac Baru atau Cloud Mac

1. Clone repository GitHub:

```bash
git clone https://github.com/ekoardiantopro-cpu/jiix-ios-player.git
```

2. Masuk ke folder project:

```bash
cd jiix
```

3. Buka project:

```bash
open Jiix.xcodeproj
```

4. Di Xcode:
   - pilih target `Jiix`
   - buka `Signing & Capabilities`
   - pilih `Team`
   - jika perlu, ganti `Bundle Identifier` agar unik
   - klik `Run`

## Jika Ingin Install ke iPhone Fisik

1. Sambungkan iPhone ke Mac.
2. Pastikan iPhone muncul di device selector Xcode.
3. Aktifkan `Developer Mode` di iPhone jika diminta.
4. Pilih iPhone sebagai target run.
5. Klik `Run`.

## Catatan

- Repo ini belum menyertakan file audio lokal, jadi playback memakai stream sample publik.
- Untuk install ke iPhone fisik, Anda tetap perlu Xcode dan signing Apple Developer atau Personal Team.
