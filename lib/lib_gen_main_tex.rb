# lib_gen_main_tex.rb
#  -- Library ruby script to generate main.tex.

def basename(file, suffix=nil)
  suffix ? File.basename(file, suffix) : File.basename(file)
end

def gen_main_tex directory, abstractfile, texfiles, appendixfiles=nil
  #  parameter: directory: the destination directory to put generated files.
  #             texfiles: an array of latex files. Each of them is "secXX.tex" where XX is digits.

  # ------ Create helper.tex ------
  # Get preamble from a latex file generated by pandoc.
  #  1. Generate sample latex file by `pandoc -s --listings -o sample.tex sample.md`
  #  2. Extract the preamble of sample.tex.
  #  3. Add geometry package.

sample_md = <<'EOS'
# title

line1

~~~C
int main(int argc, char **argv) {
}
~~~

|English|Japanese|
|:-----:|:------:|
|potato|jagaimo|
|carrot|ninjin|
|onion|tamanegi|

EOS

  File.write "sample.md", sample_md
  stat = system("pandoc", "-s", "--listings", "-o", "sample.tex", "sample.md")
  File.delete("sample.md")
  raise ("pandoc retuns error status #{$?}.\n") unless stat == true
  sample_tex = File.read("sample.tex")
  File.delete("sample.tex")
  preamble = sample_tex.partition(/^\\begin{document}.*?\n/)[0]
  preamble.gsub!(/^\\documentclass\[.*?\]\{.*?\}.*?\n/m,"")
  preamble.gsub!(/^\\usepackage\[.*?\]\{geometry\}.*?\n/,"")
  preamble.gsub!(/^\\usepackage\[.*?\]\{graphicx\}.*?\n/,"")
  preamble.gsub!(/^\\setcounter\{secnumdepth\}\{-\\maxdimen\}.*?\n/,"")
  preamble.gsub!(/^\\author\{*?\}.*?\n/,"")
  preamble.gsub!(/^\\date\{*?\}.*?\n/,"")
  preamble.squeeze!("\n")
  preamble += <<~EOS
  \\usepackage[margin=2.4cm]{geometry}
  \\usepackage{graphicx}
  \\lstdefinelanguage[]{turtle}{
    keywords={pu, pd, pw, fd, tr, bc, fc, if, rt, rs, dp},
    comment=[l]\\#
  }
  [keywords, comments]
  \\lstset {
    extendedchars=true,
    basicstyle=\\small\\ttfamily,
    keywordstyle=\\color{red},
    commentstyle=\\color{gray},
    stringstyle=\\color{blue},
    breaklines=true,
    breakatwhitespace=true
  }
  EOS
  File.write("#{directory}/helper.tex",preamble)

  # ------ Create main.tex ------

  main = <<~EOS
  \\documentclass[a4paper]{article}
  \\include{helper.tex}
  \\title{Tutorial de Gtk4 para Principiantes}
  \\author{Toshio Sekiya}
  \\date{}
  \\begin{document}
  \\maketitle
  \\begin{center}
  \\textbf{abstract}
  \\end{center}
  \\input{#{basename(abstractfile)}}
  \\newpage
  \\tableofcontents
  \\newpage
  EOS

  texfiles.each do |filename|
    main += "  \\input{#{basename(filename)}}\n"
  end
  main += "\\newpage\n"
  main += "\\appendix\n" if appendixfiles
  appendixfiles.to_a.each do |filename|
    main += "  \\input{#{basename(filename)}}\n"
  end
  main += "\\end{document}\n"
  IO.write("#{directory}/main.tex", main)
end
