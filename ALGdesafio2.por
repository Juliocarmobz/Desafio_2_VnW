programa {
inclua biblioteca Util--> u
inclua biblioteca Calendario --> c
inclua biblioteca Texto --> tx
inclua biblioteca Tipos --> tp
//  to do list
// /* - input dos dados: fazer com que os dados sejam insediros de forma organica;
//    - conseguir acesso as datas: as datas vao ser armazanadas como inteiros [dia|mes|ano|hora|minuto] <- matriz ou vetor = resovler com timestamp
//    - verificar quantos dias faltam para o proximo evento
//    - marcar conclucao da tarefa
//    - marcar dia atual no calendario
//    - notificar o evento no dia do evento
// */ 

  inteiro diaDeEvento
  inteiro diaEventos[50]       //Armazena o dia do evento em formato unixtimestamp
  inteiro horaEventos[50]       //Armazena a hora do evento em formato unixtimestamp
  cadeia descricaoEventos[50]  //Armazena a descricao do evento
  logico estadoEvento[50]      //Armazena o estado do evento verdadeiro = concluido, falso = nao concluido
  inteiro totalEventos = 0     //Armazena o total de eventos registrados até o momento

  funcao inicio() {
    inteiro opcao
    faca{
    limpa()
    mostrarSemana(diaDeEvento)
    mostrarCalendario(diaDeEvento)
    notification(diaDeEvento)
    // menu Ok
    escreva("\n1- Criar evento")
    escreva("\n2- Consultar eventos")
    escreva("\n3- Concluir eventos")
    escreva("\n0- Para sair")
    escreva("\nQual opção você deseja?\n✎ ")
    leia(opcao)
    escolha(opcao){
      caso 0:
        escreva("\nAgradecemos por usar nosso gerenciador de eventos. Até a próxima!")
      pare
      caso 1:
        menuCriacao(diaDeEvento)
      pare
      caso 2:
        menuConsulta(diaDeEvento)
      pare
      caso 3:
        // menuConclusao(diaDeEvento)
      pare
      caso contrario:
        escreva("\nA opção que você escolheu não é válida.\n")
        keyPress()
    }
    }
    enquanto(opcao != 0)
    
  }
  //Funcao Semana Ok
  funcao vazio mostrarSemana(){
    escreva(" D   S   T   Q   Q   S   S \n\n")
  }
  funcao mostrarCalendario(){
    
    // Recupera o dia no mês atual do computador
    inteiro diaAtual = c.dia_mes_atual()
    // Serve para saber qual foi o primeiro dia da semana no caso (Domingo)
    inteiro diaUmSemana = (c.dia_semana_atual() - c.dia_mes_atual()) // 7 + 6
    inteiro quantidadeDiasFevereiro = 28
    // Ano bissexto calculo para saber se o ano é bissexto e passar o número correto de dias para fevereiro

    se((c.ano_atual() % 4 == 0 e c.ano_atual() % 100 != 0) ou (c.ano_atual() % 400 == 0)){
      quantidadeDiasFevereiro = 29
    }

    // Quantidade de dias que cada mês tem
    inteiro diasNoMes[12] = {31, quantidadeDiasFevereiro, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}

    // Var do mês e dia atual
    inteiro mesAtual = c.mes_atual()
    inteiro diaMesAtual = c.dia_mes_atual()
    
    // Loop para imprimir os dias do mês atual e do próximo mês
    para(inteiro i = -diaUmSemana + 1; i <= diasNoMes[mesAtual - 1] + diasNoMes[mesAtual]; i++){
        cadeia prefix, posfix
        inteiro dia

        se(i == diaMesAtual){
            prefix = "("
            posfix = ")"
        } senao{
            prefix = " "
            posfix = " "
        }

        se(i >= 0 e i <= diasNoMes[mesAtual - 1]){
            dia = i
        } senao se(i > diasNoMes[mesAtual - 1]){
            dia = i - diasNoMes[mesAtual - 1]
        } senao {
            dia = i + diasNoMes[mesAtual]
        }

        se(dia < 10){
            prefix= prefix + "0"
        }

        escreva(prefix,dia,posfix) 
        
        se ((i + diaUmSemana ) % 7 == 0) {
            escreva("\n")
        }
    }
  }
  funcao vazio menuCriacao(){
    cadeia descricao, dataTexto
    inteiro dataLeitura[5]
    escreva("\nQual é a descrição do evento?\n")
    leia(descricao)
    faca{
      escreva("\nQuando será o evento?\nFavor informar no padrão [DD-MM-AAAA HH:MM].\n✎ ")
      leia(dataTexto)
      se(tx.numero_caracteres(dataTexto) != 16)
        escreva("Formato de data inválido.\n")
    }enquanto(tx.numero_caracteres(dataTexto) != 16)
    dataLeitura = text2DataArray(dataTexto)
    push(dataLeitura, descricao)
    escreva("\nEvento registrado com sucesso!\n")
    escreva(totalEventos)
    keyPress()
  }
  funcao inteiro text2DataArray(cadeia data){
    inteiro retorno[5] = {0,0,0,0,0}
    se(tx.numero_caracteres(data) == 16){
      retorno[0] = tp.cadeia_para_inteiro(tx.extrair_subtexto(data,0,2),10) //dia
      retorno[1] = tp.cadeia_para_inteiro(tx.extrair_subtexto(data,3,5),10) //mes
      retorno[2] = tp.cadeia_para_inteiro(tx.extrair_subtexto(data,6,10),10) //ano
      retorno[3] = tp.cadeia_para_inteiro(tx.extrair_subtexto(data,11,13),10) //hora
      retorno[4] = tp.cadeia_para_inteiro(tx.extrair_subtexto(data,14,16),10) //minuto
    }
    retorne retorno
  }

   funcao vazio menuConsulta(){
    inteiro consulta = 1
    inteiro i = 0
    escreva("\n1- Consultar todos")
    escreva("\n2- Consultar por data")
    escreva("\nQual opção você deseja?\n✎ ")
    leia(consulta)
    escolha(consulta){
      caso 1:
        para(i = 0; i < totalEventos; i++){
          printEvent(i)
        }
        se(totalEventos == 0) 
          escreva("\nSem eventos registrados.\n")
        keyPress()
      pare
      caso 2:
        inteiro busca[50], dataPesquisa[5]
        cadeia leituraDataPesquisa
        faca{
          escreva("Precisamos da data no formato [DD-MM-AAAA] para realizar a busca.\n✎ ")
          leia(leituraDataPesquisa)
          se(tx.numero_caracteres(leituraDataPesquisa) != 10)
            escreva("Formato de data inválido.\n\n")
        }enquanto(tx.numero_caracteres(leituraDataPesquisa) != 10)
        dataPesquisa = text2DataArray(leituraDataPesquisa + " 00:00")
        busca = search4Data(dataPesquisa)
        para(i = 1; i< busca[0]; i++){
          printEvent(busca[i])}     
        se(busca[0] == 1){
          escreva("\nSem eventos registrados nessa data.\n")
          }
        keyPress()
      pare
    }
  }

  // funcoes push e search
  // funcao push
  funcao vazio push(inteiro data[], cadeia descricao) {
    inteiro dataConvertida[2]
    dataConvertida = dataArray2Timestamp(data)
    diaEventos[totalEventos] = dataConvertida[0] 
    horaEventos[totalEventos] = dataConvertida[1]
    descricaoEventos[totalEventos] = descricao
    estadoEvento[totalEventos] = falso
    totalEventos++
    bubbleSort()
  }


    // Converte array de data para timestamp [dia|mes|ano|hora|minuto] -> timestamp
  funcao inteiro dataArray2Timestamp(inteiro data[]){
    inteiro totalDias = (data[2] - 1970) * 365 + (data[1] - 1) * 30 + data[0]
    inteiro unixTimestampData = totalDias * 24 * 60 * 60
    inteiro unixTimestampHora = data[3] * 60 * 60 + data[4] * 60
    inteiro retorno[2] = {unixTimestampData, unixTimestampHora}
    retorne retorno
  }

  //  Organiza a lista de evento no push
  // https://pt.wikipedia.org/wiki/Bubble_sort
  //  O algoritmo pode ser mais performatico se trocar uma linha pela variavel totalEventos (dica: começa com n)
  funcao vazio bubbleSort(){
		inteiro i, j, tempDia, tempHora, n
    cadeia tempDescricao
    logico tempEstado
    n = totalEventos
		para(i = 0; i < n-1; i++){
			para(j = 0; j < n-i-1; j++){
				se (diaEventos[j]+horaEventos[j] > diaEventos[j+1]+horaEventos[j+1]) {
					// Para o dia
          tempDia = diaEventos[j]
					diaEventos[j] = diaEventos[j+1]
					diaEventos[j+1] = tempDia
          // para a hora
          tempHora = horaEventos[j]
					horaEventos[j] = horaEventos[j+1]
					horaEventos[j+1] = tempHora
          // para a descricao
          tempDescricao = descricaoEventos[j]
					descricaoEventos[j] = descricaoEventos[j+1]
					descricaoEventos[j+1] = tempDescricao
          // para o estado
          tempEstado = estadoEvento[j]
					estadoEvento[j] = estadoEvento[j+1]
					estadoEvento[j+1] = tempEstado
				}
			}
		}
	}

  // Funcao que imprime um evento
  funcao vazio printEvent(inteiro i){
    inteiro horarioEvento[5]
      horarioEvento = timestamp2DataArray(diaEventos[i]+horaEventos[i]) 
      escreva("\nEvento: ",i)
      escreva("\nDescrição: ",descricaoEventos[i])
      se(estadoEvento[i])
        escreva("\nEstado: ☑")
      senao
        escreva("\nEstado: ☐")
      escreva("\n",horarioEvento[0],"-",horarioEvento[1], "-",horarioEvento[2], " as ",horarioEvento[3],":",horarioEvento[4],"\n")
  }


  // nao foi mexido
  
   // unix -> data [dia|mes|ano|hora|minuto]
  funcao inteiro timestamp2DataArray(inteiro unixTimestamp){
        inteiro totalSegundos = unixTimestamp
        inteiro totalMinutos = totalSegundos / 60
        inteiro totalHoras = totalMinutos / 60
        inteiro totalDias = totalHoras / 24
        inteiro minuto = totalMinutos % 60
        inteiro hora = totalHoras % 24
        inteiro ano = totalDias / 365 + 1970
        inteiro mes = (totalDias % 365) / 30 + 1
        inteiro dia = (totalDias % 365) % 30
        inteiro retorno[5] = {dia, mes, ano, hora, minuto}
        retorne retorno
  }



  // funcao de busca por data
  funcao inteiro search4Data(inteiro data[]){
    inteiro indices[50]
    
    inteiro inicio = 0
		inteiro fim = totalEventos - 1
		inteiro meio
    inteiro parcial[2]
    parcial = dataArray2Timestamp(data)
    inteiro dataTimestamp = parcial[0]
    inteiro ultimoIndicie = 1
    // 1 2 3 4 5 6 7 8 9 10
    enquanto(inicio <= fim){
      meio = (inicio + fim)/2
      se(diaEventos[meio] == dataTimestamp){
        indices[ultimoIndicie] = meio
        ultimoIndicie++
        inicio = meio + 1
      }senao se(diaEventos[meio] < dataTimestamp){
        inicio = meio + 1
      }senao {
        fim = meio - 1
      }
    }
    indices[0] = ultimoIndicie
    retorne indices
}

  funcao vazio notification() {
    inteiro busca[50]
    inteiro data[] = {c.dia_mes_atual(), c.mes_atual(), c.ano_atual(),0,0}
    busca = search4Data(data)
    se(busca[0] != 1){
      escreva("\n➧ Você tem ",busca[0]-1," evento(s) hoje.\n")
    }
  }

  //keyPress Ok
  funcao vazio keyPress(){
    escreva("\nPressione enter para continuar.\n")
    cadeia _
    leia(_)
  }
}