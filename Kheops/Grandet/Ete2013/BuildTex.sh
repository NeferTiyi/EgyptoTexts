#!/bin/tcsh

set Project = "Grandet2013"
set DataDir = "../../img/${Project}/Done"

set FileList = `ls ${DataDir}/${Project}*.xcf`

set TexFile = "${Project}_inc.tex"
rm ${TexFile}

set ConvertOpt = "-quality 100 -density 100x100 -scale 25%"

set PageFirst = "true"

set DocTitle = ( "Inscription de Merenptah - Karnak" \
                 "Grande inscription de l'an~8"      )
@ DocNum = 1

foreach FileIn ( ${FileList} )
  
  set FileBase = `basename ${FileIn} .xcf`
  
  set PageNum = `echo ${FileBase} | gawk -F "_" '{ print $2 }'`
  set LineNum = `echo ${FileBase} | gawk -F "_" '{ print $3 }'`

  # echo ${PageNum} ${LineNum}

  if ( ! -f ${DataDir}/${FileBase}.png ) then
    echo "convert ${ConvertOpt} ${DataDir}/${FileBase}.xcf ${DataDir}/${FileBase}.png"
    convert ${ConvertOpt}              \
            ${DataDir}/${FileBase}.xcf \
            ${DataDir}/${FileBase}.png
  endif

  switch ( ${LineNum} )
    case "L00" :
      if ( ${PageFirst} == "false" ) then
        echo "\\newpage" >> ${TexFile}
        echo "" >> ${TexFile}
      endif
      echo "\\title{$DocTitle[${DocNum}]}" >> ${TexFile}
      echo "" >> ${TexFile}
      echo "\\includeannexe{${FileBase}}" >> ${TexFile}
      echo "" >> ${TexFile}
      echo "\\vspace{2\\baselineskip}" >> ${TexFile}
      echo "" >> ${TexFile}

      set PageFirst = "false"
      @ DocNum = ${DocNum} + 1
      breaksw
    case "L99" :
      echo "\\includeannexe{${FileBase}}" >> ${TexFile}
      echo "" >> ${TexFile}
      breaksw
    default :
      echo "\\begin{ligne}" >> ${TexFile}
      echo "  \\includeligne{${PageNum}}{${LineNum}}{${FileBase}}" >> ${TexFile}
      echo "\\end{ligne}" >> ${TexFile}
      echo "" >> ${TexFile}
  endsw

end

exit
