 program tp1_4;
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


function menu():integer;
var opc: integer;
begin
    writeln('Elige una opción: ');
    writeln('==================');
    writeln('1. Ingresar información');
    writeln('2. Ver información');
    writeln('3. Borrar');
    writeln('4. Exportar');
    writeln('0. Salir');
    readln(opc);
    menu:= opc;
end;

function submenuAgregar():integer;
var opc: integer;
begin
    writeln('Ingresar información ');
    writeln('====================');
    writeln('1. Crear archivo e ingresar información');
    writeln('2. Ingresar empleados al final del archivo');
    writeln('3. Modificar edades');
    writeln('0. Volver');
    readln(opc);
    submenuAgregar:= opc;
end;

function submenuExportar():integer;
var opc: integer;
begin
    writeln('Exportar');
    writeln('========');
    writeln('1. Exportar todos los empleados');
    writeln('2. Exportar empleados que no tienen DNI definido');
    writeln('0. Volver');
    readln(opc);
    submenuExportar:= opc;
end;

function submenuBorrar():integer;
var opc: integer;
begin
    writeln('Borrar');
    writeln('========');
    writeln('1. Borrar viendo los empleados de forma secuencial');
    writeln('2. Borrar por numero de empleado');
    writeln('0. Volver');
    readln(opc);
    submenuBorrar:= opc;
end;

function submenuMostrar():integer;
var opc: integer;
begin
    writeln('Abrir archivo: ');
    writeln('==================');
    writeln('1. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.');
    writeln('2. Listar en pantalla los empleados de a uno por línea');
    writeln('3. Listar en pantalla empleados mayores de 70 años');
    writeln('0. Volver');
    readln(opc);
    submenuMostrar:= opc;
end;


procedure crearEmpleados(archivo: str20; tipo: str8);
var empleados: archivo; emp: empleado; cont: integer;
begin
    
    assign(empleados, 'data/ej1/'+ archivo+'.dat');
    case tipo of
        'new': begin
                cont:=1;
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
            end;
        'end': begin
                reset(empleados);
                cont:=fileSize(empleados)+1;
                seek(empleados, fileSize(empleados));
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
        end;
    end;
    ClrScr;
end;

procedure exportar(archivo:str20; tipo: str8);
var
    texto: Text;
    empleados: archivo;
    emp: empleado;
begin
    assign(empleados, 'data/ej1/'+ archivo+'.dat');
    reset(empleados);
    case tipo of 
        'full': begin
            assign(texto, 'data/ej1/todos_empleados.txt');
            rewrite(texto);
            while(not eof(empleados)) do begin
                Read(empleados, emp);
                with emp do writeln(texto, ' ', apellido, ' ', nombre, ' ', dni, ' ', edad, ' ', n_emp);
            end;
        end;
        'dni': begin
            assign(texto, 'data/ej1/faltaDNIEmpleado.txt');
            rewrite(texto);
            while(not eof(empleados)) do begin
                Read(empleados, emp);
                if(emp.dni=00) then begin
                    With emp do writeln(texto, ' ', apellido, ' ', nombre, ' ', dni, ' ', edad, ' ', n_emp);
                end;
            end;
        end;
    end;
    writeln('Archivo exportado correctamente...');
    close(empleados);
    close(texto);
end;

procedure imprimirEmpleado(emp: empleado);
begin
    writeln('Empleado #', emp.n_emp, ': ');
    writeln('===============');
    writeln('Apellido: '+emp.apellido);
    writeln('Nombre: '+emp.nombre);
    writeln('Edad: ',emp.edad);
    writeln('DNI: ',emp.dni);
    writeln();
end;

procedure modificarEdad(archivo: str20);
var
    empleados: archivo;
    emp: empleado;
    opc: str8;
    edad: longint;
begin
    assign(empleados, 'data/ej1/'+archivo+'.dat');
    reset(empleados);
    while(not eof(empleados)) do begin
        Read(empleados, emp);
        imprimirEmpleado(emp);
        writeln('Desea cambiar la edad de este empleado: (s/n): ');
        readln(opc);
        if(opc='s') then begin
            writeln('Introduzca la nueva edad: ');
            readln(edad);
            emp.edad:=edad;
            seek(empleados, filePos(empleados)-1);
            write(empleados, emp);
            writeln('Editado correctamente...');
        end;

    end;
    close(empleados);
end;

procedure leerUltimo(var empleados: archivo; var emp: empleado);
var 
    pos: integer;
begin
    pos:=filePos(empleados)-1;
    seek(empleados, fileSize(empleados)-1);
    read(empleados, emp);
    seek(empleados, filePos(empleados)-1);
    Truncate(empleados);
    reset(empleados);
    seek(empleados, pos);
end;

procedure borrar(archivo: str20; tipo: str20);
var
    empleados: archivo;
    emp, emp_ul: empleado;
    opc: str8;
    num: integer;
    borrado: boolean;
begin
    assign(empleados, 'data/ej1/'+archivo+'.dat');
    reset(empleados);
    case tipo of
        'secuencial': begin
                while(not eof(empleados)) do begin
                    Read(empleados, emp);
                    imprimirEmpleado(emp);
                    writeln('Desea borrar este empleado: (s/n): ');
                    readln(opc);
                    if(opc='s') then begin
                        leerUltimo(empleados, emp_ul);
                        write(empleados, emp_ul);
                        writeln('Borrado correctamente...');
                    end;

                end;
            end;
        'numero': begin
                writeln('Ingrese el numero de empleado que desea borrar: ');
                readln(num);
                borrado:=false;
                while(not eof(empleados)) do begin
                    read(empleados, emp);
                    if(emp.n_emp=num) then begin
                        leerUltimo(empleados, emp_ul);
                        write(empleados, emp_ul);
                        borrado:=true;
                    end;
                end;
                if(borrado)then
                    writeln('Borrado correctamente')
                else
                    writeln('El empleado no existia en base de datos');

        end;
    end;

    close(empleados);
end;


procedure listarEmpleados(archivo: str20; tipo: str8);
var 
    nombre: str20;
    empleados: archivo;
    emp: empleado;
    cont: integer;
begin
    assign(empleados, 'data/ej1/'+ archivo+'.dat');
    reset(empleados);
    cont:=0;
    ClrScr;
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
                        subopc:= submenuAgregar();
                        case subopc of
                            1: crearEmpleados(archivo_nombre, 'new');
                            2: crearEmpleados(archivo_nombre, 'end');
                            3: modificarEdad(archivo_nombre);
                        end;
                    end;
                    2: begin
                        ClrScr;
                        subopc:= submenuMostrar();
                        case subopc of
                            1: listarEmpleados(archivo_nombre, 'filter');
                            2: listarEmpleados(archivo_nombre, 'full');
                            3: listarEmpleados(archivo_nombre, 'old');
                        end;
                    end;
                    3: begin
                        ClrScr;
                        subopc:= submenuBorrar();
                        case subopc of
                            1: borrar(archivo_nombre, 'secuencial');
                            2: borrar(archivo_nombre, 'numero');
                        end;
                        
                    end;
                    4: begin
                        ClrScr;
                        subopc:= submenuExportar();
                        case subopc of
                            1: exportar(archivo_nombre, 'full');
                            2: exportar(archivo_nombre, 'dni');
                        end;
                    end;
                    0: fin:= true;
                end;

                
            until (fin);
           
    end.