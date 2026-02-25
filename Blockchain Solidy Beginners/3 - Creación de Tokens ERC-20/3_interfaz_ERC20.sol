// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/**
 * @title IERC20 Interface
 * @dev Interfaz del estándar ERC20 (Ethereum Request for Comments 20).
 *
 * ¿QUÉ ES UNA INTERFAZ?
 * En Solidity, una interfaz es como un "contrato de servicios". Define QUÉ funciones
 * debe tener un contrato para ser compatible con el estándar, pero no CÓMO funcionan por dentro.
 *
 * IMPORTANCIA:
 * Permite la "Componibilidad". Cualquier plataforma (Uniswap, carteras, otros contratos)
 * puede interactuar con tu token sin ver tu código fuente, solo necesitan conocer esta interfaz.
 */
interface IERC20 {
    /**
     * @dev Supply Total: Cantidad total de tokens que existirán.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Balance: Consulta cuántos tokens tiene una dirección específica.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Transferencia Directa: Envía tokens desde quien llama la función (msg.sender) a 'to'.
     * @return bool Confirmación de si la operación tuvo éxito.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Permiso (Allowance): Consulta cuánto dinero tiene permitido gastar un 'spender'
     * en nombre de un 'owner'. Es la base de las aplicaciones DeFi.
     */
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    /**
     * @dev Aprobación (Approve): El dueño de los tokens autoriza a un 'spender' (ej: un Exchange)
     * a retirar hasta 'amount' tokens de su cuenta.
     * SEGURIDAD: Es necesario para que contratos inteligentes puedan mover tus tokens.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Transferencia Delegada: Permite que un tercero (ej: un contrato de Staking)
     * mueva tokens de 'from' a 'to', siempre que tenga permiso previo (allowance).
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Evento Transfer: Se dispara en cada movimiento de tokens.
     * 'indexed' permite que aplicaciones externas (Frontend) filtren transferencias por dirección.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Evento Approval: Se dispara cuando se cambia un permiso de gasto.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

/**
 * @title Implementación de ERC20
 * @dev Este contrato implementa la lógica real del token.
 */
contract ERC20 is IERC20 {
    // Almacenamiento de datos:
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    /**
     * @dev El constructor inicializa los metadatos. El nombre y símbolo son inmutables
     * si no se crean funciones para cambiarlos.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    // --- Funciones de Lectura (View) ---

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual returns (uint8) {
        // Por estándar, 18 decimales permite una precisión similar al ETH (Wei).
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(
        address account
    ) public view virtual override returns (uint256) {
        return _balances[account];
    }

    // --- Lógica de Transferencias ---

    /**
     * @notice Envía tokens propios a otra dirección.
     */
    function transfer(
        address to,
        uint amount
    ) public virtual override returns (bool) {
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
    }

    /**
     * @notice Consulta el permiso de gasto actual.
     */
    function allowance(
        address owner,
        address spender
    ) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @notice Autoriza a un tercero a gastar tus tokens.
     */
    function approve(
        address spender,
        uint256 amount
    ) public virtual override returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, amount);
        return true;
    }

    /**
     * @notice Ejecuta una transferencia en nombre de otro (requiere aprobación previa).
     * PATRÓN DeFi: Primero el usuario hace 'approve' al contrato, y luego el contrato hace 'transferFrom'.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = msg.sender;
        _spendAllowances(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    // --- Funciones de Gestión de Permisos ---

    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public virtual returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, _allowances[owner][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(
        address spender,
        uint256 substractedValue
    ) public virtual returns (bool) {
        address owner = msg.sender;
        uint256 currentAllowance = _allowances[owner][spender];
        require(
            currentAllowance >= substractedValue,
            "ERC20: permiso menor a cero"
        );

        // UNCHECKED: Ahorra gas cuando ya hemos validado manualmente con el 'require'
        // que no habrá underflow (resultado negativo).
        unchecked {
            _approve(owner, spender, currentAllowance - substractedValue);
        }
        return true;
    }

    // --- Lógica Interna (Seguridad) ---

    /**
     * @dev Lógica central de movimiento de tokens.
     * SEGURIDAD: Validamos que las direcciones no sean cero (la dirección 0 se usa para quemar).
     */
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(
            from != address(0),
            "ERC20: transferencia desde direccion cero"
        );
        require(to != address(0), "ERC20: transferencia a direccion cero");

        // HOOK: Permite añadir lógica extra antes de transferir (ej: listas blancas) sin tocar esta función.
        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: saldo insuficiente");

        unchecked {
            // Unchecked aquí es seguro porque el 'require' anterior garantiza que fromBalance >= amount.
            _balances[from] = fromBalance - amount;
        }
        _balances[to] += amount;

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }

    /**
     * @dev Crea tokens nuevos. Solo se usa internamente (ej: en el constructor o recompensas).
     */
    function _mint(address account, uint amount) internal virtual {
        require(account != address(0), "ERC20: minteo a direccion cero");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Destruye tokens. Envía tokens a la dirección 0.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: quema desde direccion cero");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(
            accountBalance >= amount,
            "ERC20: saldo insuficiente para quemar"
        );
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Actualiza el mapeo de permisos. Lanza el evento Approval.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve desde direccion cero");
        require(spender != address(0), "ERC20: approve a direccion cero");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Gasta el permiso otorgado. Si el permiso es infinito (max uint), no lo resta (ahorro gas).
     */
    function _spendAllowances(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: permiso insuficiente");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    /**
     * @dev Hooks: Estos espacios se dejan vacíos para que, si heredas este contrato,
     * puedas añadir funcionalidades (ej. snapshots, pausas) sin modificar el código base.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}
