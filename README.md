##### Ellaco is a manager for automating download lists based on ` youtube-dl`

**Bitcoin (BTC) [![Donate](https://img.shields.io/badge/Donate-green)](https://idpay.ir/oky2abbas): `1HPZyUP9EJZi2S87QrvCDrE47qRV4i5Fze`**

**Ethereum (ETH) [![Donate](https://img.shields.io/badge/Donate-green)](https://idpay.ir/oky2abbas): `0x4a4b0A26Eb31e9152653E4C08bCF10f04a0A02a9`**

**Tron (TRX) [![Donate](https://img.shields.io/badge/Donate-green)](https://idpay.ir/oky2abbas): `TAewZVAD4eKjPo9uJ5TesxJUrXiBtVATsK`**



##### Feature

- [x] download video in (`channel` & `playlist` & `direct link` in ` youtube`)
- [x] download **HLS** video by direct link
- [x] add the embedded `subtitle` by `Youtube Machine Learning` or `attached subtitle`
- [x] categorize files as folders
- [x] maximum download speed with concurrent connections
- [ ] **?**

##### Dependency : youtube-dl & ffmpeg
- In **macOS**
- > ```bash
  > brew install youtube-dl ffmpeg aria2
  > ```
- In **debian** base
- > ```shell
  > sudo apt update && sudo apt install youtube-dl ffmpeg aria2
  > ```
- In **readhat** base
- > ```shell
  > sudo yum update && sudo yum install youtube-dl ffmpeg aria2
  > ```

##### How to use this ?
- ###### Download bash file 
- >```shell
  >wget https://raw.githubusercontent.com/dfmabbas/ellaco/master/ellaco.sh
  >```
- ###### start comment  
- > ```shell
  > bash ellaco.sh -t video -q highest -s en -f ls.txt
  > bash ellaco.sh -t audio -f ls.txt
  > bash ellaco.sh -t hls -q best -f ls.txt
  > ```
- `-t` type - default video - for example video, music, hls, audio (only best audio)
- `-q` quality **(optional)** - default highest - for example best, highest, audio (only best audio)
- `-s` subtitle **(optional)** - for example en, fa, fr, ar, sp and ...
- `-m` max file size **(optional)** - default 2g - for example 100k, 100m ...
- `-p` path **(optional)** - default current path - for example ~/Downloads
- `-f` input file **(sample of the file is available in the repository)**

  -  `youtube channel sample` https://www.youtube.com/channel/id
  -  `youtube playlist sample` https://www.youtube.com/playlist?list=id
  -  `youtube video sample` https://www.youtube.com/watch?v=id

#### enjoy :)