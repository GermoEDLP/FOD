 program tp1_3;
 uses Crt;
 type
    str20 = string[20];
    str8 = string[8];
    empleado = record
        nombre: str20;
        apellido: str20;
        edad: integer;
        dni: longint;
        n_emp: integer;
    end;
    archivo = file of empleado;

 var
    emp : empleado;
    opc: integer;

function menu():integer;
var opc: integer;
begin
    writeln('Elige una opción: ');
    writeln('==================');
    writeln('1. Crear archivo e ingresar información');
    writeln('2. Abrir archivo');
    writeln('0. Salir');
    readln(opc);
    menu:= opc;
end;
function submenu():integer;
var opc: integer;
begin
    writeln('Abrir archivo: ');
    writeln('==================');
    writeln('1. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.');
    writeln('2. Listar en pantalla los empleados de a uno por línea');
    writeln('3. Listar en pantalla empleados mayores de 70 años');
    writeln('0. Volver');
    readln(opc);
    submenu:= opc;
end;

function crearEmpleados(archivo: str20):boolean;
var empleados: archivo; emp: empleado; cont: integer;
begin
    cont:=1;
    assign(empleados, 'data/'+ archivo+'.txt');
    rewrite(empleados);
    writeln('Ingrese el apellido del empleado #', cont);
    readln(emp.apellido);
    while (emp.apellido <> 'fin') do begin
        writeln('Ingrese el nombre del empleado #', cont);
        readln(emp.nombre);
        writeln('Ingrese la edad del empleado #', cont);
        readln(emp.edad);
        writeln('Ingrese el dni del empleado #', cont);
        readln(emp.dni);
        writeln('Ingrese el N° de empleado del empleado #', cont);
        readln(emp.n_emp);
        write(empleados, emp);
        cont:= cont+1;
        writeln('Ingrese el apellido del empleado #', cont);
        readln(emp.apellido);
        writeln();
    end;
    close(empleados);
    ClrScr;
    crearEmpleados:=true;
end;

function imprimirEmpleado(emp: empleado): boolean;
begin
    writeln('Empleado #', emp.n_emp, ': ');
    writeln('=================');
    writeln('Apellido: '+emp.apellido);
    writeln('Nombre: '+emp.nombre);
    writeln('Edad: ',emp.edad);
    writeln('DNI: ',emp.dni);
    writeln();
    imprimirEmpleado:= true;
end;


function listarEmpleados(archivo: str20; tipo: str8):boolean;
var 
    nombre: str20;
    empleados: archivo;
    emp: empleado;
    cont: integer;
begin
    assign(empleados, 'data/'+ archivo+'.txt');
    reset(empleados);
    cont:=0;
    case tipo of
        'filter': begin 
                    writeln('Ingrese el nombre o apellido a filtrar: ');
                    readln(nombre);
                    while (not eof(empleados)) do begin
                        Read(empleados, emp);
                        if((emp.apellido = nombre) or (emp.nombre = nombre)) then begin
                            imprimirEmpleado(emp);
                            cont:=cont+1;
                        end;
                    end;
                    if (cont = 0) then begin 
                        writeln('No hay empleados con nombre o apellido igual a '+nombre);
                        writeln();
                    end;
                  end;
        'full': begin 
                    if (eof(empleados)) then begin 
                        writeln('No hay empleados en la BD.');
                    end;
                    while (not eof(empleados)) do begin
                        Read(empleados, emp);
                        imprimirEmpleado(emp);
                    end;
                  end;
        'old': begin                    
                    while (not eof(empleados)) do begin
                        Read(empleados, emp);
                        if (emp.edad >= 70) then begin 
                            imprimirEmpleado(emp);
                            cont:= cont + 1;
                        end;
                    end;
                    if (cont = 0) then begin 
                        writeln('No hay empleados mayores de 70 años.');
                        writeln();
                    end;
                  end;
    end;
    listarEmpleados:=true;
end;


    var 
        archivo_nombre: str20;
        fin: boolean;
        opcion, subopc: integer;
    begin
            fin:=false;
            writeln('Ingrese el nombre del archivo a trabajar: ');
            readln(archivo_nombre);
            repeat
                opcion:= menu();
                case opcion of
                    1: begin 
                    ClrScr;
                    crearEmpleados(archivo_nombre);
                    end;
                    2: begin
                    ClrScr;
                    subopc:= submenu();
                    case subopc of
                        1: listarEmpleados(archivo_nombre, 'filter');
                        2: listarEmpleados(archivo_nombre, 'full');
                        3: listarEmpleados(archivo_nombre, 'old');
                    end;
                    end;
                    0: fin:= true;
                end;

                
            until (fin);
           
    end.