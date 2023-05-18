// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.11;

contract Lottery {
    address[] public players;  // 참가자들의 주소를 저장하는 배열
    address public manager;  // 관리자의 주소
    uint public counter;
    uint public prizePool;  // 상금 풀의 금액
    uint public constant minimumBet = 0.1 ether;  // 최소 베팅 금액

    constructor() {
        manager = msg.sender;  // 컨트랙트 생성자가 호출될 때, 관리자를 설정
    }

    function enterLottery() public payable {
        require(msg.value >= minimumBet);  // 최소 베팅 금액 이상을 지불했는지 확인
        players.push(msg.sender);  // 참가자 목록에 추가
        counter++;
        prizePool += msg.value;  // 상금 풀에 베팅 금액 추가
    }

    function pickWinner() public restricted {
        require(players.length > 0);  // 참가자가 한 명 이상인지 확인
        uint winnerIndex = random() % players.length;  // 랜덤한 인덱스 선택
        address payable winner = payable(players[winnerIndex]);  // 당첨자 지정
        winner.transfer(prizePool);  // 상금 지급
        players = new address[](0);  // 참가자 목록 초기화
        prizePool = 0;  // 상금 풀 초기화
        counter = 0;
    }

    function random() private view returns (uint) {
    return uint(keccak256(abi.encodePacked(block.timestamp, players.length, block.basefee)));  // 랜덤한 값을 생성하여 반환
	}


    modifier restricted() {
        require(msg.sender == manager);  // 관리자만 호출할 수 있도록 제한
        _;
    }
}