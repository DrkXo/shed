enum Routes {
  loading('loading', '/loading'),
  error('error', '/error'),
  settings('settings', '/settings'),
  downloads('downloads', '/downloads'),
  add('add', 'add');

  const Routes(this.name, this.path);
  final String name;
  final String path;
}
