// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.4;

/**
 * @title Funciones: Pure y View
 * @dev Muestra la diferencia entre funciones que leen el estado (view) y funciones
 *      que no leen ni modifican el estado (pure).
 */
contract functions {

    // ==========================================
    // Funciones Pure (Puras)
    // ==========================================
    
    /**
     * @notice Devuelve un nombre estático.
     * @dev Las funciones 'pure' NO leen ni modifican el estado de la blockchain.
     *      Todo lo que necesitan está en sus argumentos o en el código mismo.
     *      No consumen gas si se llaman externamente (desde fuera de la blockchain).
     * @return El nombre "Sergio".
     */
    function getName() public pure returns(string memory) {
        return "Sergio";
    }

    // ==========================================
    // Funciones View (Vista / Lectura)
    // ==========================================
    
    // Variable de estado (almacenada en la blockchain)
    uint256 x = 100;

    /**
     * @notice Devuelve el doble del número almacenado en 'x'.
     * @dev Las funciones 'view' leen el estado de la blockchain (en este caso, la variable 'x')
     *      pero NO lo modifican.
     *      No consumen gas si se llaman externamente (call), pero sí si son llamadas por otra función
     *      dentro de una transacción que modifica el estado.
     * @return El valor de x multiplicado por 2.
     */
    function getNumber() public view returns(uint256) {
        return x * 2;
    }

}