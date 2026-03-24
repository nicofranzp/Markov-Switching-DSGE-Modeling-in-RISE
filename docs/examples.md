# Examples

## Basic Workflow
```matlab
m = dsge('my_model.rs');
m = set(m, 'parameters', param_struct);
m = solve(m);
results = estimate(m, 'data', data_struct);
fcst = forecast(m, ...);
```

## Reporting Example
```matlab
rep = rise_report.report('name','MyReport');
rep.section('title','Results');
rep.table('data', results);
rep.save('output/report.pdf');
```

See the RISE toolbox examples folder for more.