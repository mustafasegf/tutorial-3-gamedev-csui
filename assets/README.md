
## double jump
Untuk double jump, saya menggunakan jump counter dan logic `is__on_floor`. Kalau di lantai, maka jump jadi 0. Jika up di pencet dan lagi di lantai, maka lompat dengan normal dan increment jump counter. Kalau up di pencet tapi sedan diudara, maka increment jump dinaikan dan nyalakan timer untuk memastikan bahwa next jump perlu ada timeout. Logic timeout ini dipakai agar lompatan terjeda.

## double tap to dash
Ada function `_input` yang dipanggil pada semua input. Saya mengecek jika left or right dipencet. Kalau dipencet maka set counter timer deadline dan last action. jika button selanjutnya masih sama dengan button sebelumnya dan timer masih positif. Maka double dash menyala. Saya juga menambahkan efek shader trailing jika ada double tap.

## wall grab
Untuk wall grab, jika `is_on_wall` true, maka velocity dibuat 0 dan mengecek apa jump dipencet. Jika iya maka jump dari wall.

### misc
Saya menambahkan efek shader untuk death animation. ada shader disintegrade, shockwave, chromatic aberation. Ada juga simple sound effect yang dimainkan. Untuk winning condition hanya ada sound effect.
