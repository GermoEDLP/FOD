 program tp2_1;
    const v_a = 9999;
 type
    empleados_ingreso = record
        cod: integer;
        nombre: string[20];
        monto: double;
    end;
    archivo = file of empleados_ingreso;

procedure leer(	var empleados: archivo; var emp: empleados_ingreso);
begin
    if (not(EOF(empleados))) then 
       read (empleados, emp)
    else 
		    emp.cod := v_a;
end;


procedure listar(archivo: string);
var
    empleados: archivo;
    emp: empleados_ingreso;
begin
    assign(empleados, 'data/'+archivo+'.dat');
    reset(empleados);
    while(not eof(empleados)) do begin
        read(empleados, emp);
        writeln();
        writeln('Codigo: ', emp.cod, ' | Nombre: ', emp.nombre);
        writeln('Monto: ', emp.monto:0:2);
    end;
    writeln();
    close(empleados);
end;

function agregarEmpleado(): empleados_ingreso;
var 
    emp: empleados_ingreso;
begin
    writeln();
    writeln('Código: ');
    readln(emp.cod);
    writeln('Nombre: ');
    readln(emp.nombre);
    writeln('Monto: ');
    readln(emp.monto);
    agregarEmpleado:=emp;
end;

procedure agregarEmpleados();
var
    empleados: archivo;
    emp: empleados_ingreso;
    add: char;
begin
    assign(empleados, 'data/empleados.dat');
    rewrite(empleados);
    seek(empleados, fileSize(empleados));
    writeln('Desea agregar un empleado (s/n): ');
    readln(add);
    while(add='s')do begin
        emp := agregarEmpleado();
        write(empleados, emp);
        writeln('Desea agregar otro empleado (s/n): ');
        readln(add);
    end;
    close(empleados);
end;

procedure grabarFusion(emp: empleados_ingreso);
var
    empleadosFusionados: archivo;
begin
    assign(empleadosFusionados, 'data/empleadosFusionados.dat');
    reset(empleadosFusionados);
    seek(empleadosFusionados, fileSize(empleadosFusionados));
    write(empleadosFusionados, emp);
    close(empleadosFusionados);
end;


procedure fusionar();
var
    empleados: archivo;
    emp: empleados_ingreso;
    empAux: empleados_ingreso;
begin
    assign(empleados, 'data/empleados.dat');
    reset(empleados);
    leer(empleados, emp);
    while(emp.cod<>v_a) do begin
        empAux.nombre:=emp.nombre;
        empAux.cod:=emp.cod;
        empAux.monto:=0;
        while(empAux.cod=emp.cod)do begin
            empAux.monto:=empAux.monto+emp.monto;
            leer(empleados, emp);
        end;
        grabarFusion(empAux);
        // seek(empleados, filePos(empleados)-1);
    end;
    writeln();
    close(empleados);

end;

    begin
            // agregarEmpleados();
            fusionar();
            listar('empleados');
            listar('empleadosFusionados');           
    end.
