program tp2_8;
	const valor_alto = 9999;
	type
		nombre = string[30];
        cliente = record
            cod: integer;
            nombre: nombre;
            apellido: nombre;
        end;
		reg_venta = record
			cliente: cliente;
			monto: real;
			mes: integer;
			ano: integer;
	  	end;
	ventas = file of reg_venta;

procedure leer(var archivo: ventas; var dato: reg_venta);
begin
	if (not(EOF(archivo))) then 
		read (archivo, dato)
	else 
		dato.cliente.cod := valor_alto;
end;

procedure importar();
var
    archivo: ventas;
    reg: reg_venta;
    texto: Text;
begin
    assign(archivo, 'dataEj8/maestro.dat');
    rewrite(archivo);
    assign(texto, 'dataEj8/maestro.txt');
    reset(texto);
    while(not eof(texto)) do begin
        //cod monto nombre
        //mes ano apellido
        readln(texto, reg.cliente.cod, reg.monto, reg.cliente.nombre);
        readln(texto, reg.mes, reg.ano, reg.cliente.apellido);
        write(archivo, reg);
    end;
    close(archivo);
    close(texto);
    writeln('Archivo maestro importado correctamente!!');
    writeln();
end;

var
 	reg: reg_venta;
 	archivo: ventas;
 	total, totCliente, totMes, totAno: real;
 	mes, ano, cli: integer;
begin
    importar();
    writeln('Presione ENTER para continuar.');
    readln();
    assign(archivo, 'dataEj8/maestro.dat');
    reset(archivo);
    leer(archivo, reg);
    total := 0;
    while (reg.cliente.cod <> valor_alto)do begin
        writeln('Cliente: ', reg.cliente.cod, ' | ', reg.cliente.nombre, ' ', reg.cliente.apellido);
        totCliente:=0;
        cli:= reg.cliente.cod;
        while(cli=reg.cliente.cod)do begin
            writeln();
            writeln('Año: ', reg.ano);
            writeln('---------');
            totAno:=0;
            ano:=reg.ano;
            while((cli=reg.cliente.cod) and (ano=reg.ano)) do begin
                writeln('Mes: ', reg.mes);
                totMes:=0;
                mes:=reg.mes;
                while((cli=reg.cliente.cod) and (ano=reg.ano) and (mes=reg.mes)) do begin
                    totMes:=totMes+reg.monto;
                    leer(archivo, reg);
                end;
                writeln('Total mes: $', totMes:0:2);
                totAno:=totAno+totMes;
            end;
            writeln();
            writeln('--------------------------');
            writeln('Total año ', ano,': $', totAno:0:2);
            writeln('--------------------------');
            totCliente:=totCliente+totAno;
        end;
        writeln();
        writeln('--------------------------');
        writeln('Total cliente ', cli,': $', totCliente:0:2);
        writeln('--------------------------');
        total:=total+totCliente;
    end;
    writeln();
    writeln('--------------------------');
    writeln('Total empresa: $', total:0:2);
    writeln('--------------------------');
end.



