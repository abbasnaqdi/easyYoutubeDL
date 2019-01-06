**Ellaco** is a manager for automating download lists based on` youtube-dl` and `aria2c`

**Feature** 

- [x] download audio or video or both in (`channel` & `playlist` & `direct link` in ` youtube`)
- [x] add the embedded `subtitle` by `Youtube Machine Learning`
- [x] download `any file` by aria2c
- [x] categorize files as folders



**Dependency **`youtube-dl` & `aria2c` & `ffmpeg`

`in macOS`

​	`brew install aria2c && brew install ffmpeg && brew install youtube-dl`

`in gnu/linux`

​	`apt install aria2c && apt install ffmpeg && apt install youtube-dl`



**How to use this ?** ‍

download manual `ellaco.sh` or auto download by `wget‍‍`

​	`wget https://raw.githubusercontent.com/dfmabbas/ellaco/master/ellaco.sh`



​	**$terminal** -> `bash ellaco.sh -q best -s fa -f ls.txt`

​	`-q` quality

​	`-s` subtitle language

​	`-f` input file **(sample of the file is available in the repository)**

​		`aria2c link sample` http://mirror.umd.edu/linuxmint/images/stable/19.1/linuxmint-19.1-cinnamon-32bit.iso

​		`youtube channel sample` https://www.youtube.com/channel/UCxbd5nlCc3nyA1dSRo3cQTw

​		`youtube playlist sample` https://www.youtube.com/watch?v=qk5F6Bxqhr4&list=PLWz5rJ2EKKc9CBxr3BVjPTPoDPLdPIFCE

​		`youtube vodeo sample` https://www.youtube.com/watch?v=0GS2rxROcPo



**enjoy :)**