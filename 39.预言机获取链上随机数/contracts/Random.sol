// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./ERC721.sol";

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract Random is ERC721, VRFConsumerBaseV2Plus {
    // NFT相关
    uint256 public totalSupply = 100; // 总供给
    uint256[100] public ids; // 用于计算可供mint的tokenId
    uint256 public mintCount; // 已mint数量

    // chainlink VRF参数
    /**
     * 使用chainlink VRF，构造函数需要继承 VRFConsumerBaseV2
     * 不同链参数填的不一样
     * 网络: Sepolia测试网
     * https://docs.chain.link/vrf/v2-5/getting-started
     * https://docs.chain.link/vrf/v2-5/supported-networks#sepolia-testnet
     */
    uint256 subscriptionId; // 申请的`Subscription Id`
    address vrfCoordinator; // VRF 协调员
    bytes32 keyHash; // 密钥哈希
    uint16 requestConfirmations = 3; // 确认块数（数字大安全性高，一般填12）
    uint32 callbackGasLimit = 1_000_000; // `VRF`手续费。最大 2,500,000
    uint32 numWords = 1; // 请求的随机数个数, 一次可以得到的随机数个数 : 最大 500
    uint256 public requestId; // 申请标识符
    mapping(uint256 => address) public requestToSender; // 记录VRF申请标识对应铸造的用户地址。

    /**
     * 假设合约部署在 Sepolia 测试网络上，因此 VRF 协调器地址 (vrfCoordinator) 和密钥哈希 (s_keyHash) 已经作为常量定义在合约中。
     *
     * 通过继承 VRFConsumerBaseV2Plus，构造函数初始化了 VRF 协调器地址
     */
    constructor(
        uint256 _subscriptionId,
        address _vrfCoordinator,
        bytes32 _keyHash
    ) VRFConsumerBaseV2Plus(_vrfCoordinator) ERC721("luode", "ld") {
        // 设置合约的订阅 ID 为传入的参数值。
        // 这是 Chainlink VRF v2+ 的订阅 ID，合约将使用这个订阅 ID 来请求随机数
        // 这个订阅必须已经在 Chainlink 网络中创建，并且已经充值了足够的 LINK 代币，以确保合约可以成功请求随机数。
        subscriptionId = _subscriptionId;
        vrfCoordinator = _vrfCoordinator;
        keyHash = _keyHash;
    }

    // 利用链上伪随机数铸造NFT
    function mintRandomOnchain() public {
        uint256 _tokenId = pickRandomUniqueId(getRandomOnchain()); // 利用链上随机数生成tokenId
        _mint(msg.sender, _tokenId);
    }

    /**
     * 链上伪随机数生成
     *
     * 此函数尝试在以太坊链上生成一个伪随机数。
     * 生成随机数的过程中使用了链上的全局变量，如区块哈希、调用者的地址和区块时间戳。
     * 这些变量虽然提供了某种程度的随机性，但并不能保证绝对的安全性。
     *
     * 为了提高随机性，可以考虑添加更多的变量，如交易的 nonce 等。
     * 但请注意，这种方法本质上仍存在可预测性，尤其是在攻击者可以控制某些变量的情况下。
     *
     * 返回的随机数为 uint256 类型。
     */
    function getRandomOnchain() public view returns (uint256) {
        // 生成一个字节数组，包含三个变量：区块哈希、调用者的地址和区块时间戳
        bytes32 randomBytes = keccak256(
            abi.encodePacked(
                blockhash(block.number - 1), // 上一个区块的哈希值
                msg.sender, // 调用者的地址
                block.timestamp // 当前区块的时间戳
            )
        );
        // 将生成的字节数组转换为 uint256 类型的随机数
        return uint256(randomBytes);
    }

    /**
     * 输入uint256数字，返回一个可以mint的tokenId, random由预言机/获得
     */
    function pickRandomUniqueId(
        uint256 random
    ) private returns (uint256 tokenId) {
        //先计算减法，再计算++, 关注(a++，++a)区别
        uint256 len = totalSupply - mintCount++; // 可mint数量
        require(len > 0, "mint close"); // 所有tokenId被mint完了
        uint256 randomIndex = random % len; // 获取链上随机数

        //随机数取模，得到tokenId，作为数组下标，同时记录value为len-1，如果取模得到的值已存在，则tokenId取该数组下标的value
        tokenId = ids[randomIndex] != 0 ? ids[randomIndex] : randomIndex; // 获取tokenId
        ids[randomIndex] = ids[len - 1] == 0 ? len - 1 : ids[len - 1]; // 更新ids 列表
        ids[len - 1] = 0; // 删除最后一个元素，能返还gas
    }

    /**
     * 调用 VRF 获取随机数，并 mint NFT
     *
     * 此函数首先调用 VRF Coordinator 的 `requestRandomWords` 方法来请求随机数。
     * 消耗随机数的逻辑被写在 VRF 的回调函数 `fulfillRandomWords` 中。
     *
     * 在调用此函数之前，需要确保在 Subscriptions 中为 VRF 服务提供了足够的 LINK 代币。
     */
    function mintRandomVRF() public {
        // 向 VRF 协调器请求随机数。
        // 如果订阅未设置或资金不足，此操作将回退。
        requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: keyHash, // 密钥哈希用于识别 VRF 订阅。
                subId: subscriptionId, // 用于资助 VRF 请求的订阅 ID。
                requestConfirmations: requestConfirmations, // 请求确认数
                callbackGasLimit: callbackGasLimit, // 回调函数的最大 gas 限制。
                numWords: numWords, // 请求的随机数数量。
                extraArgs: VRFV2PlusClient._argsToBytes(
                    // 额外参数用于 VRF 请求。这里我们指定请求应该使用 LINK 代币支付。
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            })
        );

        requestToSender[requestId] = msg.sender;
    }

    /**
     * VRF 的回调函数，由 VRF Coordinator 调用
     *
     * 此函数在 VRF Coordinator 返回随机数后被调用，用于处理随机数并 mint NFT。
     *
     * @param _requestId 请求 ID，用于标识此次随机数请求
     * @param _randomWords 包含随机数的数组, 有多少个随机数由之前的numWords控制
     */
    function fulfillRandomWords(
        uint256 _requestId,
        uint256[] calldata _randomWords
    ) internal override {
        // 从requestToSender中获取minter用户地址
        address sender = requestToSender[_requestId];
        // 利用VRF返回的随机数生成tokenId
        uint256 tokenId = pickRandomUniqueId(_randomWords[0]);
        _mint(sender, tokenId);
    }
}
