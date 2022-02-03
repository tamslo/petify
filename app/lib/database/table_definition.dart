class TableDefinition {
  final String name;
  final Map<String, String> fields;
  final dynamic model;
  final List<String> parentTables;

  // Could also check naming conventions (foreign key) and fields/types
  TableDefinition({
    required this.name,
    required this.fields,
    required this.model,
    this.parentTables = const [],
  });

  String getCreateStatement() {
    final String fieldStatement = fields.keys
        .map((fieldName) => '$fieldName ${fields[fieldName]}')
        .toList()
        .join(", ");
    final String rulesStatement = parentTables.isNotEmpty
        ? ', ' +
            parentTables
                .map((parentTable) =>
                    'FOREIGN KEY(${parentTable.substring(0, parentTable.length - 1)}Id) REFERENCES $parentTable(id)')
                .join(" ")
        : '';
    return 'CREATE TABLE $name('
        '$fieldStatement'
        '$rulesStatement'
        ')';
  }
}
