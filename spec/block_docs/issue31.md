Markdown should be processed inside span-level tags. https://github.com/bhollis/maruku/issues/31
*** Parameters: ***
{}
*** Markdown input: ***
<span>*hello*</span>
*** Output of inspect ***
md_el(:document, md_par(md_html("<span>*hello*</span>")))
*** Output of to_html ***
<p><span><em>hello</em></span></p>
