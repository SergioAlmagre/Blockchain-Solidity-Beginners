// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title Envío y Recepción de Ether
 * @dev Muestra las tres formas principales de enviar Ether en Solidity:
 *      1. transfer()
 *      2. send()
 *      3. call() - La forma recomendada actualmente.
 */
contract ethSend {
    /**
     * @notice Constructor pagable. Permite enviar Ether al contrato al momento de desplegarlo.
     */
    constructor() payable {}

    /**
     * @notice Permite al contrato recibir Ether sin llamar a ninguna función específica.
     */
    receive() external payable {}

    // Eventos para rastrear el estado de los envíos
    event sendStatus(bool);
    event callStatus(bool, bytes);

    /**
     * @notice Enviar Ether usando 'transfer'.
     * @dev Limitado a 2300 de gas, lo suficiente solo para registrar un evento básico.
     *      Si falla, REVIERTE la transacción automáticamente.
     *      Ya NO se recomienda su uso por problemas de compatibilidad con gas.
     * @param _to La dirección destinataria.
     */
    function sendViaTransfer(address payable _to) public payable {
        // Envía 1 Ether. Si no tiene suficiente saldo o falla, lanza una excepción.
        _to.transfer(1 ether);
    }

    /**
     * @notice Enviar Ether usando 'send'.
     * @dev También limitado a 2300 de gas.
     *      A diferencia de 'transfer', devuelve un booleano (false) si falla, NO revierte.
     *      Se debe manejar el error manualmente con 'require'.
     * @param _to La dirección destinataria.
     */
    function sendViaSend(address payable _to) public payable {
        // Devuelve true si el envío fue exitoso, false si falló.
        bool sent = _to.send(1 ether);
        emit sendStatus(sent);
        require(sent == true, "El envio ha fallado");
    }

    /**
     * @notice Enviar Ether usando 'call'.
     * @dev Es la forma RECOMENDADA actualmente.
     *      No tiene límite de gas por defecto (envía todo el gas disponible), permitiendo
     *      lógica compleja en el contrato receptor.
     *      Devuelve un booleano de éxito y datos de retorno.
     * @param _to La dirección destinataria.
     */
    function sendViaCall(address payable _to) public payable {
        // call{value: ...}("") realiza una llamada de bajo nivel enviando Ether.
        (bool success, bytes memory data) = _to.call{value: 1 ether}("");
        emit callStatus(success, data);
        require(success == true, "El envio ha fallado");
    }
}

/**
 * @title Receptor de Ether
 * @dev Contrato simple para recibir Ether y registrar el gas recibido.
 */
contract ethReceiver {
    event log(uint amount, uint gas);

    /**
     * @notice Se ejecuta al recibir Ether.
     * @dev Emite un log con el balance actual y el gas restante.
     *      Útil para comprobar cuánto gas llega dependiendo del método de envío usado
     *      (transfer/send vs call).
     */
    receive() external payable {
        emit log(address(this).balance, gasleft());
    }
}
