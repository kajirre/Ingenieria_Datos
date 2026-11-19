// =====================================================================================
// SanaRed · Parcial final de Ingeniería de Datos (Universidad del Rosario)
// Crea la base "sanared" con 30 sedes, 300 pacientes y 60.000 citas.
// Cómo ejecutarlo en Compass: abre este archivo, copia todo (Ctrl+A, Ctrl+C), pégalo en la
// consola mongosh de Compass y pulsa Enter. Tarda entre 20 y 60 segundos.
// Se puede ejecutar varias veces: borra y recarga, y siempre genera exactamente los mismos datos.
// =====================================================================================
db = db.getSiblingDB("sanared");
["citas","sedes","pacientes","autorizaciones","resumen_procedimientos"].forEach(function (c) { db.getCollection(c).drop(); });

var rnd = (function (a) { return function () { a |= 0; a = a + 0x6D2B79F5 | 0; var t = Math.imul(a ^ a >>> 15, 1 | a); t = t + Math.imul(t ^ t >>> 7, 61 | t) ^ t; return ((t ^ t >>> 14) >>> 0) / 4294967296; }; })(3031);
function entero(min, max) { return min + Math.floor(rnd() * (max - min + 1)); }
function elegir(lista) { return lista[Math.floor(rnd() * lista.length)]; }
function ponderado(pares) { var x = rnd(), s = 0; for (var i = 0; i < pares.length; i++) { s += pares[i][1]; if (x < s) return pares[i][0]; } return pares[pares.length - 1][0]; }

// ---------- sedes: [id, nombre, ciudad, barrio, longitud, latitud, consultorios, consultorios_libres, tipo]
var SITIOS = [
  ["S01","SanaRed Chicó","Bogotá","Chicó",-74.0478,4.6772,30,21,"especializada"],
  ["S02","SanaRed El Retiro","Bogotá","El Retiro",-74.0525,4.668,24,4,"especializada"],
  ["S03","SanaRed Calle 100","Bogotá","Chicó Norte",-74.056,4.6862,20,11,"básica"],
  ["S04","SanaRed Usaquén","Bogotá","Usaquén",-74.0305,4.695,18,3,"básica"],
  ["S05","SanaRed El Virrey","Bogotá","Chicó",-74.056,4.6735,26,15,"especializada"],
  ["S06","SanaRed Chapinero","Bogotá","Chapinero",-74.064,4.643,22,9,"básica"],
  ["S07","SanaRed Candelaria","Bogotá","La Candelaria",-74.0735,4.6005,28,6,"especializada"],
  ["S08","SanaRed Salitre","Bogotá","Salitre",-74.0935,4.6585,30,19,"especializada"],
  ["S09","SanaRed Teusaquillo","Bogotá","Teusaquillo",-74.0695,4.615,20,12,"básica"],
  ["S10","SanaRed Santa Bárbara","Bogotá","Santa Bárbara",-74.0425,4.702,16,9,"básica"],
  ["S11","SanaRed Lleras","Medellín","El Poblado",-75.5672,6.2093,28,17,"especializada"],
  ["S12","SanaRed Provenza","Medellín","El Poblado",-75.564,6.2105,20,3,"especializada"],
  ["S13","SanaRed Poblado","Medellín","El Poblado",-75.5765,6.2115,30,22,"especializada"],
  ["S14","SanaRed Carabobo","Medellín","Carabobo Norte",-75.5655,6.271,22,8,"básica"],
  ["S15","SanaRed Los Balsos","Medellín","Los Balsos",-75.5785,6.2005,26,14,"especializada"],
  ["S16","SanaRed Laureles Estadio","Medellín","Laureles",-75.5895,6.2565,24,5,"básica"],
  ["S17","SanaRed Centro Berrío","Medellín","La Candelaria",-75.569,6.251,18,10,"básica"],
  ["S18","SanaRed Ciudad del Río","Medellín","Ciudad del Río",-75.5775,6.2235,20,12,"especializada"],
  ["S19","SanaRed Envigado","Medellín","Envigado",-75.5915,6.171,16,2,"básica"],
  ["S20","SanaRed Laureles Primer Parque","Medellín","Laureles",-75.5905,6.2445,22,13,"básica"],
  ["S21","SanaRed San Fernando","Cali","San Fernando",-76.5412,3.4476,26,16,"especializada"],
  ["S22","SanaRed Bulevar","Cali","Centro",-76.535,3.451,30,6,"especializada"],
  ["S23","SanaRed San Antonio","Cali","San Antonio",-76.5395,3.4495,18,11,"básica"],
  ["S24","SanaRed Ciudad Jardín","Cali","Ciudad Jardín",-76.53,3.373,24,15,"especializada"],
  ["S25","SanaRed Meléndez","Cali","Meléndez",-76.5325,3.3765,28,4,"especializada"],
  ["S26","SanaRed Granada","Cali","Granada",-76.5315,3.4615,20,12,"básica"],
  ["S27","SanaRed Pascual Guerrero","Cali","San Fernando",-76.544,3.431,22,13,"básica"],
  ["S28","SanaRed Chipichape","Cali","Chipichape",-76.5275,3.476,20,3,"básica"],
  ["S29","SanaRed Caicedo","Cali","Centro",-76.531,3.4535,16,9,"básica"],
  ["S30","SanaRed Santander","Cali","Santander",-76.5235,3.4655,18,10,"básica"]
];
var sedes = SITIOS.map(function (e) {
  return { _id: e[0], nombre: e[1], ciudad: e[2], barrio: e[3], ubicacion: { type: "Point", coordinates: [e[4], e[5]] },
           consultorios: e[6], consultorios_libres: e[7], tipo: e[8], estado: "abierta" };
});
db.sedes.insertMany(sedes);

// ---------- pacientes
var CIUDADES = ["Bogotá", "Medellín", "Cali"];
var NOMBRES = ["Ana", "Luis", "Camila", "Andrés", "Valentina", "Santiago", "Daniela", "Juan", "Laura", "Mateo", "Sofía", "Felipe", "Mariana", "Carlos", "Isabella", "Diego", "Paula", "Sebastián", "Natalia", "Tomás"];
var APELLIDOS = ["Gómez", "Rodríguez", "Martínez", "López", "García", "Pérez", "Ramírez", "Torres", "Díaz", "Moreno", "Rojas", "Vargas", "Castro", "Ortiz", "Jiménez", "Herrera", "Suárez", "Mejía", "Restrepo", "Cárdenas"];
var pacientes = [];
for (var u = 1; u <= 300; u++) {
  var nom = elegir(NOMBRES), ape = elegir(APELLIDOS);
  pacientes.push({ _id: "P" + String(u).padStart(3, "0"), nombre: nom + " " + ape,
    correo: (nom + "." + ape + u).toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "") + "@correo.co",
    ciudad: CIUDADES[(u - 1) % 3], afiliacion: ponderado([["EPS",0.55],["prepagada",0.25],["particular",0.2]]),
    fecha_registro: new Date(Date.UTC(2024, 0, 1, 5) + entero(0, 820) * 86400000),
    estado: rnd() < 0.1 ? "inactivo" : "activo" });
}
db.pacientes.insertMany(pacientes);

// ---------- citas
var porCiudad = {};
CIUDADES.forEach(function (c) { porCiudad[c] = { sitios: sedes.filter(function (e) { return e.ciudad === c; }), personas: pacientes.filter(function (x) { return x.ciudad === c; }) }; });
var PESO_SITIO = [0.16, 0.13, 0.11, 0.08, 0.12, 0.09, 0.10, 0.08, 0.07, 0.06];
var HORAS = [[6,4],[7,10],[8,12],[9,11],[10,10],[11,8],[12,3],[13,4],[14,9],[15,10],[16,8],[17,6],[18,3]];
var TOTAL_H = HORAS.reduce(function (s, h) { return s + h[1]; }, 0);
var BASE = Date.UTC(2026, 0, 1, 5);               // 1 de enero de 2026, 00:00 hora de Colombia
var DIAS = 304;                                   // hasta el 31 de octubre de 2026
var NOVEDADES = ["laboratorio","imagen","vacuna","curación","electrocardiograma"];   // la última solo ocurre con profesional de tipo "especialista"

function sitioPonderado(lista) { return lista[ponderado(PESO_SITIO.map(function (p, i) { return [i, p]; }))]; }
function evento(n) {
  var ciudad = ponderado([["Bogotá", 0.42], ["Medellín", 0.33], ["Cali", 0.25]]);
  var L = porCiudad[ciudad];
  var p = elegir(L.personas);
  var o = sitioPonderado(L.sitios), d = sitioPonderado(L.sitios);
  var hora = ponderado(HORAS.map(function (h) { return [h[0], h[1] / TOTAL_H]; }));
  var inicio = new Date(BASE + entero(0, DIAS - 1) * 86400000 + hora * 3600000 + entero(0, 3599) * 1000);
  var especial = o.tipo === "especializada" && rnd() < 0.45;
  var recurso = { id: "M" + ((CIUDADES.indexOf(ciudad) + 1) * 1000 + entero(1, 400)), tipo: especial ? "especialista" : "general" };
  var v = { numero: n, paciente: { id: p._id, afiliacion: p.afiliacion }, profesional: recurso,
            sede: { sede_id: o._id, nombre: o.nombre, ciudad: ciudad },
            inicio: inicio };
  if (rnd() < 0.09) {
    var dc = entero(0, 2);
    v.fin = new Date(inicio.getTime() + dc * 60000); v.duracion_min = dc; v.examenes_ordenados = 0; v.valor = 0;
    v.estado = "cancelada"; v.procedimientos = [];
    return v;
  }
  var dur = Math.min(90, 15 + Math.floor(-Math.log(1 - rnd()) * 9) + entero(0, 5));
  var plan = p.afiliacion;
  var valor = plan === "EPS" ? 4800 : plan === "prepagada" ? 28000 + 500 * Math.max(0, dur - 20) : 65000 + 1500 * Math.max(0, dur - 20);
  if (especial) valor += 45000;
  var arr = [], x = rnd();
  var k = x < 0.015 ? 2 : x < 0.095 ? 1 : 0;
  for (var i = 0; i < k; i++) {
    var tipo = elegir(especial ? NOVEDADES : NOVEDADES.slice(0, 4));
    arr.push({ tipo: tipo, prioridad: ponderado([["baja", 0.5], ["media", 0.32], ["alta", 0.18]]) });
  }
  v.fin = new Date(inicio.getTime() + dur * 60000);
  v.duracion_min = dur;
  v.examenes_ordenados = entero(0, especial ? 4 : 2);
  v.valor = valor;
  v.estado = "atendida";
  v.calificacion = Math.max(1, Math.min(5, ponderado([[5, 0.45], [4, 0.33], [3, 0.14], [2, 0.05], [1, 0.03]]) - arr.length));
  v.procedimientos = arr;
  return v;
}
var lote = [];
for (var n = 1; n <= 60000; n++) {
  lote.push(evento(n));
  if (lote.length === 5000) { db.citas.insertMany(lote); lote = []; print("Citas insertados: " + n); }
}
print("Sedes: " + db.sedes.countDocuments());
print("Pacientes: " + db.pacientes.countDocuments());
print("Citas: " + db.citas.countDocuments());