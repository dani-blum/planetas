import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:myapp/modelo/planeta.dart';

/// Classe responsável pelo gerenciamento do banco de dados SQLite dos planetas.
class PlanetaDatabase {
  static final PlanetaDatabase instance = PlanetaDatabase._init(); // Instância singleton
  static Database? _database; // Banco de dados

  PlanetaDatabase._init(); // Construtor privado para garantir que apenas uma instância exista

  /// Obtém o banco de dados, inicializando-o se necessário.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('planetas.db');
    return _database!;
  }

  /// Inicializa o banco de dados SQLite e define o caminho onde será armazenado.
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); // Obtém o diretório do banco de dados
    final path = join(dbPath, filePath); // Cria o caminho completo

    return await openDatabase(
      path,
      version: 1, // Versão do banco de dados
      onCreate: _createDB, // Chama o método para criar as tabelas na primeira execução
    );
  }

  /// Cria a tabela de planetas no banco de dados.
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE planetas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        distanciaSol REAL NOT NULL,
        tamanho REAL NOT NULL,
        apelido TEXT
      )
    ''');
  }

  /// Insere um novo planeta no banco de dados.
  Future<int> createPlaneta(Planeta planeta) async {
    final db = await instance.database;
    return await db.insert('planetas', planeta.toMap());
  }

  /// Lê os dados de um planeta específico pelo ID.
  Future<Planeta?> readPlaneta(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'planetas',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Planeta.fromMap(maps.first);
    } else {
      return null;
    }
  }

  /// Retorna uma lista com todos os planetas cadastrados.
  Future<List<Planeta>> readAllPlanetas() async {
    final db = await instance.database;
    final result = await db.query('planetas');

    return result.map((map) => Planeta.fromMap(map)).toList();
  }

  /// Atualiza os dados de um planeta existente.
  Future<int> updatePlaneta(Planeta planeta) async {
    final db = await instance.database;
    return await db.update(
      'planetas',
      planeta.toMap(),
      where: 'id = ?',
      whereArgs: [planeta.id],
    );
  }

  /// Remove um planeta do banco de dados pelo ID.
  Future<int> deletePlaneta(int id) async {
    final db = await instance.database;
    return await db.delete(
      'planetas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Fecha a conexão com o banco de dados.
  Future<void> close() async {
    final db = await _database;
    if (db != null) {
      await db.close();
    }
  }
}
