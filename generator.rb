# encoding: utf-8

10.times do |i|
	m = 2**(i+5)

	puts "\\subsubsection{#{m} bytes}
\\begin{figure}[h!]
    \\centering
        \\includegraphics[width=0.64\\textwidth]{../figs/D1/plot_estimation_#{m}.pdf}
        \\caption{Estimaciones en D1.dat con #{m} bytes}
    \\label{figura:D1_estimation_#{m}}
\\end{figure}

\\begin{figure}[h!]
    \\centering
        \\includegraphics[width=0.64\\textwidth]{../figs/D1/plot_errors_#{m}.pdf}
        \\caption{Errores relativos en D1.dat con #{m} bytes}
    \\label{figura:D1_errors_#{m}}
\\end{figure}

\\begin{figure}[h!]
    \\centering
        \\includegraphics[width=0.64\\textwidth]{../figs/D1/plot_count_#{m}.pdf}
        \\caption{Clasificación de ejecuciones en D1.dat con #{m} bytes}
    \\label{figura:D1_count_#{m}}
\\end{figure}

\\begin{figure}[h!]
    \\centering
        \\includegraphics[width=0.64\\textwidth]{../figs/D1/plot_time_#{m}.pdf}
        \\caption{Tiempos de ejecución en D1.dat con #{m} bytes}
    \\label{figura:D1_time_#{m}}
\\end{figure}

\\clearpage"
end
