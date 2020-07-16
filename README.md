##### Ellaco is a manager for automating download lists based on` youtube-dl`



[![Donate](https://img.shields.io/badge/Donate-green)](https://idpay.ir/oky2abbas)

**Bitcoin (BTC) Donate: `bc1qhgvnx2nfzr0qep5fnsevyyn59k32wpe7q0c7nh`**

**Ethereum (ETH) Donate: `0x0dA44bbcc2d7BBF11eb070A81CB24c4eE7Bf1AD9`**



##### Feature

- [x] download  video in (`channel` & `playlist` & `direct link` in ` youtube`)
- [x] add the embedded `subtitle` by `Youtube Machine Learning`
- [x] categorize files as folders
- [x] 16 concurrent connections
- [ ] **?**

##### Dependency : youtube-dl & ffmpeg
- In **macOS**
- > ```bash
  > brew install youtube-dl ffmpeg aria2
  > ```
- In **debian** base
- > ```shell
  > sudo apt update
  > sudo apt install youtube-dl ffmpeg aria2
  > ```
- In **readhat** base
- > ```shell
  > sudo yum update
  > sudo yum install youtube-dl ffmpeg aria2
  > ```

##### How to use this ?
- ###### Download bash file 
- >```shell
  >wget https://raw.githubusercontent.com/dfmabbas/ellaco/master/ellaco.sh
  >```
- ###### start comment  
- > ```shell
  > bash ellaco.sh -q highest -s fa -f ls.txt
  > ```
- `-q` quality **(optional)** - default highest - for example best, highest, audio (only best audio)
- `-s` subtitle **(optional)** - for example en, fa, fr, ar, sp and ...
- `-m` max file size **(optional)** - default 2g - for example 100k, 100m ...
- `-p` path **(optional)** - default current path - for example ~/Downloads
- `-f` input file **(sample of the file is available in the repository)**

  -  `youtube channel sample` https://www.youtube.com/channel/id
  -  `youtube playlist sample` https://www.youtube.com/playlist?list=id
  -  `youtube video sample` https://www.youtube.com/watch?v=id

#### enjoy :)