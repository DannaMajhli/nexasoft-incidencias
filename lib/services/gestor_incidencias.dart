import '../data/almacen_local.dart';
import '../model/incidencia.dart';

class GestorIncidencias {
  final AlmacenLocal datos = AlmacenLocal();
  List<Incidencia> incidencias = [];

  Future<void> iniciar() async {
    incidencias = await datos.leer();
  }

  List<Incidencia> buscar(String texto) {
    texto = texto.trim().toLowerCase();

    if (texto.isEmpty) return incidencias;

    return incidencias
        .where(
          (x) =>
              x.titulo.toLowerCase().contains(texto) ||
              x.descripcion.toLowerCase().contains(texto),
        )
        .toList();
  }

  Incidencia? porId(String id) {
    for (var x in incidencias) {
      if (x.id == id) return x;
    }
    return null;
  }

  int contar(String estado) {
    return incidencias.where((x) => x.estado == estado).length;
  }

  Future<void> cambiarEstado(String id, String estado) async {
    for (var i = 0; i < incidencias.length; i++) {
      if (incidencias[i].id == id) {
        incidencias[i].estado = estado;
        await datos.guardar(incidencias);
        break;
      }
    }
  }

  Future<void> cambiarPrioridad(String id, String prioridad) async {
  for (var i = 0; i < incidencias.length; i++) {
    if (incidencias[i].id == id) {
      incidencias[i].prioridad = prioridad;
      await datos.guardar(incidencias);
      break;
    }
  }
}

  Future<void> crear(
    String titulo,
    String descripcion,
    String cliente,
    String categoria,
    String prioridad,
  ) async {
    final nuevo = Incidencia(
      id: 'INC-${DateTime.now().microsecondsSinceEpoch}',
      titulo: titulo,
      descripcion: descripcion,
      cliente: cliente,
      categoria: categoria,
      estado: 'Pendiente',
      fecha: DateTime.now().toIso8601String().split('T').first,
      prioridad: prioridad,
    );

    incidencias.insert(0, nuevo);
    await datos.guardar(incidencias);
  }

  Future<void> reiniciarDemo() async {
    await datos.restaurarDatosDeEjemplo();
    await iniciar();
  }
}
