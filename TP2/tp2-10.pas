program tp2_10;
	const valor_alto = 'ZZZ';
	type
		str20 = string[20];
		empleado = record
			depto: str20;
			division: str20;
			n_emp: integer;
			cat: integer;
            horas: integer;
	  	end;
    array_montos = array [1..15] of real;
	maestro = file of empleado;

procedure leer(var archivo: maestro; var dato: empleado);
begin
	if (not(EOF(archivo))) then 
		read (archivo, dato)
	else 
        // El primer valor por el que se ordena
		dato.depto := valor_alto;
end;

procedure importarMaestro();
var
    archivo: maestro;
    reg: empleado;
    texto: Text;
begin
    assign(archivo, 'dataEj10/maestro.dat');
    rewrite(archivo);
    assign(texto, 'dataEj10/maestro.txt');
    reset(texto);
    while(not eof(texto)) do begin
        //n_emp cat division
        //horas depto
        readln(texto, reg.n_emp, reg.cat, reg.division);
        readln(texto, reg.horas, reg.depto);
        write(archivo, reg);
    end;
    close(archivo);
    close(texto);
    writeln('Archivo maestro importado correctamente!!');
    writeln();
end;

procedure importarMontos(var montos: array_montos);
var
    texto: Text;
    i: integer;
    monto: real;
begin
    assign(texto, 'dataEj10/montos.txt');
    reset(texto);
    while(not eof(texto)) do begin
        readln(texto, i, monto);
        montos[i]:=monto;
    end;
    close(texto);
    writeln();
    writeln('Montos importados correctamente!!');
end;

var
 	reg: empleado;
 	archivo: maestro;
    montos: array_montos;
 	totalMonto_depto, totalMonto_division, monto: real;
 	totalHoras_depto, totalHoras_division: integer;
    division, depto: str20;
begin
    importarMontos(montos);
    importarMaestro();
    writeln('Presione ENTER para continuar.');
    readln();
    
    assign(archivo, 'dataEj10/maestro.dat');
    reset(archivo);
    leer(archivo, reg);
    while (reg.depto <> valor_alto)do begin
        writeln();
        writeln('===================================');
        writeln('Departamento ', reg.depto);
        writeln('===================================');
        writeln();
        totalMonto_depto := 0;
        totalHoras_depto:=0;
        depto:=reg.depto;
        while(depto=reg.depto)do begin
            writeln();
            writeln('División: ', reg.division);
            writeln('---------------------------');
            totalMonto_division:=0;
            totalHoras_division:=0;
            division:=reg.division;
            writeln('Numero de empleado     Total de hs.     Importe a cobrar');
            while((depto=reg.depto) and (division=reg.division)) do begin
                monto:=reg.horas*montos[reg.cat];
                writeln(reg.n_emp, '                      ', reg.horas, '               ', monto:0:2);
                totalHoras_division:=totalHoras_division+reg.horas;
                totalMonto_division:=totalMonto_division+monto;
                leer(archivo, reg);
            end;
            writeln();
            writeln('----------------------------------------------');
            writeln('Total horas división: ', totalHoras_division);
            writeln('Total monto división: ', totalMonto_division:0:2);
            writeln('----------------------------------------------');
            totalMonto_depto:=totalMonto_depto+totalMonto_division;
            totalHoras_depto:=totalHoras_depto+totalHoras_division;
        end;
        writeln();
        writeln('----------------------------------------------');
        writeln('Total horas departamento: ', totalHoras_depto);
        writeln('Total monto departamento: ', totalMonto_depto:0:2);
        writeln('----------------------------------------------');
    end;
end.



