// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts@4.4.2/token/ERC721/ERC721.sol";
// Ownable: Librería que proporciona un modificador 'onlyOwner', restringiendo
// ciertas funciones para que solo el desplegador del contrato pueda usarlas.
import "@openzeppelin/contracts@4.4.2/access/Ownable.sol";

/**
 * @title Colección de Arte NFT
 * @dev Implementación avanzada de ERC-721. Incluye minteo con coste (ethers),
 * metadatos pseudo-aleatorios (ADN, rareza), niveles, y retiro de fondos.
 */
contract ArtToken is ERC721, Ownable {

    /**
     * @dev Constructor del Smart Contract
     * @param _name Nombre de la colección.
     * @param _symbol Símbolo de la colección.
     */
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    // Contador de NFTs: Se usa para asignar un ID único a cada obra de arte.
    uint256 COUNTER;

    // Precio fijo del NFT (en Ethers). '5 ether' automáticamente hace la conversión a Wei (5 * 10^18).
    uint256 public price = 5 ether;

    /**
     * @dev Estructura de datos que define los atributos de cada obra de arte (Metadata).
     */
    struct Art {
        string name;
        uint256 id;
        uint256 dna;
        uint8 level;
        uint8 rarity;
    }

    // Array que almacena todas las obras de arte creadas.
    // El índice del array coincide con el ID del NFT (COUNTER).
    Art[] public art_works;

    /**
     * @dev Evento que notifica al exterior (ej: frontend) que se ha creado una nueva obra.
     */
    event NewArtWork(address indexed owner, uint256 id, uint256 dna);

    // ==========================================
    // Funciones Auxiliares e Internas
    // ==========================================

    /**
     * @dev Genera un número "aleatorio" (pseudo-aleatorio) basado en parámetros del bloque.
     * ADVERTENCIA: En producción real, los mineros podrían manipular el block.timestamp.
     * Para aleatoriedad 100% segura, se recomiendan oráculos como Chainlink VRF.
     * @param _mod Módulo para limitar el tamaño del número devuelto.
     */
    function _createRandomNum(uint256 _mod) internal view returns (uint256) {
        bytes32 hash_randomNum = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        uint256 randomNum = uint256(hash_randomNum);
        return randomNum % _mod;
    }

    /**
     * @dev Lógica interna para crear la pieza de arte y mintear el NFT.
     * @param _name Nombre de la nueva obra.
     */
    function _createArtWork(string memory _name) internal {
        uint8 randRarity = uint8(_createRandomNum(1000));
        uint256 randDna = _createRandomNum(10**16);
        
        // Creamos la obra con atributos aleatorios y nivel 1.
        Art memory newArtWork = Art(_name, COUNTER, randDna, 1, randRarity);
        art_works.push(newArtWork);
        
        // Minteamos el token al usuario de forma segura.
        _safeMint(msg.sender, COUNTER);
        
        emit NewArtWork(msg.sender, COUNTER, randDna);
        COUNTER++; // Incrementamos el ID para la próxima obra.
    }

    // ==========================================
    // Funciones de Gestión (Propietario)
    // ==========================================

    /**
     * @notice Actualiza el precio de minteo de nuevos NFTs.
     * @dev Solo el dueño del contrato (onlyOwner) puede llamar a esta función.
     */
    function updatePrice(uint256 _price) external onlyOwner {
        price = _price;
    }

    /**
     * @notice Extrae todos los Ethers acumulados en el contrato por la venta de NFTs.
     * @dev 'payable' permite que la función gestione dinero.
     */
    function withdraw() external payable onlyOwner {
        address payable _owner = payable(owner()); // Casteamos al owner a payable
        
        // call() es la forma moderna y recomendada de enviar ether en Solidity.
        (bool success, ) = _owner.call{value: address(this).balance}("");
        require(success, "La transferencia fallo"); // Revertimos si hay error.
    }

    // ==========================================
    // Funciones de Lectura Pública (View)
    // ==========================================

    /**
     * @notice Devuelve la dirección del contrato y cuánto dinero (balance) ha recaudado.
     */
    function infoSmartContract() public view returns (address, uint256) {
        address SC_address = address(this);
        // Dividimos entre 10^18 para mostrar el resultado visualmente en Ethers, no en Wei.
        uint256 SC_money = address(this).balance / 10**18;
        return (SC_address, SC_money);
    }

    /**
     * @notice Devuelve el catálogo entero de obras de arte.
     */
    function getArtWorks() public view returns (Art[] memory) {
        return art_works;
    }

    /**
     * @notice Devuelve todas las obras que posee una dirección específica.
     * @dev Hace uso de la función balanceOf() heredada de ERC721.
     */
    function getOunerArtWork(address _ownerAddress) public view returns (Art[] memory) {
        // Inicializamos un array en memoria con el tamaño exacto de NFTs que posee el usuario.
        Art[] memory result = new Art[](balanceOf(_ownerAddress));
        uint256 counter_owner = 0;
        
        // Iteramos sobre todas las obras creadas.
        for (uint256 i = 0; i < art_works.length; i++) {
            // master ownerOf() para comprobar quién es el dueño del ID 'i'.
            if (ownerOf(i) == _ownerAddress) {
                result[counter_owner] = art_works[i];
                counter_owner++;
            }
        }
        return result;
    }

    // ==========================================
    // Funciones Interactivas de los NFTs
    // ==========================================

    // NFT Token Payment
    function createRandomArtWork(string memory _name) public payable{
        require(msg.value >= price, "No has enviado suficientes ethers");
        _createArtWork(_name);
    }

    // Extraction of ethers from the Smart Contract to the Owner
    function withdraw() external payable onlyOwner {
        address payable _owner = payable(owner());
        (bool success, ) = _owner.call{value: address(this).balance}("");
        require(success, "La transferencia fallo");
    }

    // Level up NFT Tokens
    function levelUp(uint256 _artId) public {
        require(ownerOf(_artId) == msg.sender, "No eres el dueno de este arte");
        Art storage art = art_works[_artId];
        art.level++;
    }
}