##### Ellaco is a manager for automating download lists based on` youtube-dl`

##### Feature
- [x] download  video in (`channel` & `playlist` & `direct link` in ` youtube`)
- [x] add the embedded `subtitle` by `Youtube Machine Learning`
- [x] categorize files as folders
- [ ] **?**

##### Dependency : youtube-dl & ffmpeg
- In **macOS**
- > ```bash
  > brew install youtube-dl ffmpeg
  > ```
- In **debian** base
- > ```shell
  > sudo apt update
  > sudo apt install youtube-dl ffmpeg
  > ```
- In **readhat** base
- > ```shell
  > sudo yum update
  > sudo yum install youtube-dl ffmpeg 
  > ```

##### How to use this ?
- ###### Download bash file 
- >```shell
  >wget https://raw.githubusercontent.com/dfmabbas/ellaco/master/ellaco.sh
  >```
- ###### start comment  
- > ```shell
  > bash ellaco.sh -q best -s fa -f ls.txt
  > ```
- `-q` quality **(optional)** - default best - for example best
- `-s` subtitle **(optional)** - for example en, fa, fr, ar, sp and ...
- `-p` path **(optional)** - default current path - for example ~/Downloads/
- `-f` input file **(sample of the file is available in the repository)**

  - ​ `youtube channel sample` https://www.youtube.com/channel/id
  - ​ `youtube playlist sample` https://www.youtube.com/watch?v=id&list=id
  - ​ `youtube video sample` https://www.youtube.com/watch?v=id

#### enjoy :)