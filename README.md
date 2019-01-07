##### Ellaco is a manager for automating download lists based on` youtube-dl`

##### Feature
- [x] download  video in (`channel` & `playlist` & `direct link` in ` youtube`)
- [x] add the embedded `subtitle` by `Youtube Machine Learning`
- [x] categorize files as folders
- [ ] **?**

##### Dependency  `youtube-dl` & `ffmpeg`
-  `macOS`
-  > `brew install ffmpeg && brew install youtube-dl`
-  gnu/linux `debian` base
-  > `apt install ffmpeg && apt install youtube-dl`
-  gnu/linux `readhat` base
-  > `yum install ffmpeg && yum install youtube-dl`


##### How to use this ?
- ###### Download bash file 
- >`wget https://raw.githubusercontent.com/dfmabbas/ellaco/master/ellaco.sh`
- ###### start comment  
- > `bash ellaco.sh -q best -s fa -f ls.txt`
- `-q` quality `(optional)` - default best - for example best
- `-s` subtitle language `(optional)` - for example en, fa, fr, ar, sp and ...
- `-p` path `(optional)` - default current path - for example '~/Downloads/'
- `-f` input file **(sample of the file is available in the repository)**

  - ​ `youtube channel sample` https://www.youtube.com/channel/id
  - ​ `youtube playlist sample` https://www.youtube.com/watch?v=id&list=id
  - ​ `youtube vodeo sample` https://www.youtube.com/watch?v=id

#### enjoy :)