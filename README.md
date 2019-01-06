**Ellaco** is a manager for automating download lists based on` youtube-dl` and `aria2c`

##### Feature
- [x] download audio or video or both in (`channel` & `playlist` & `direct link` in ` youtube`)
- [x] add the embedded `subtitle` by `Youtube Machine Learning`
- [x] download `any file` by aria2c
- [x] categorize files as folders
- [ ] **?**

##### Dependency  `youtube-dl` & `aria2c` & `ffmpeg`
-  ###### In terminal macOS
-  > `brew install aria2 && brew install ffmpeg && brew install youtube-dl`
-  ###### In terminal gnu/linux
-  > `apt install aria2 && apt install ffmpeg && apt install youtube-dl`


##### How to use this ?
-  ###### Download bash file 
-  >`wget https://raw.githubusercontent.com/dfmabbas/ellaco/master/ellaco.sh`
- ###### start comment  
- > `bash ellaco.sh -q best -s fa -f ls.txt`
-  `-q` quality
- `-s` subtitle language
- `-f` input file **(sample of the file is available in the repository)**
  - ​ `aria2c link sample` http://mirror.umd.edu/linuxmint/name.iso
  - ​ `youtube channel sample` https://www.youtube.com/channel/id
  - ​ `youtube playlist sample` https://www.youtube.com/watch?v=id&list=id
  - ​ `youtube vodeo sample` https://www.youtube.com/watch?v=id

#### enjoy :)