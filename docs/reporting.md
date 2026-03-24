# Reporting

RISE includes a reporting system for generating tables, plots, and LaTeX/PDF/HTML reports.

## Example
```matlab
rep = rise_report.report('name','MyReport');
rep.section('title','Estimation Results');
rep.table('data', results);
rep.save('output/report.pdf');
```

See the examples folder for more reporting templates.