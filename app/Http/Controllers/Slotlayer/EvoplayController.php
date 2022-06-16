<?php

namespace App\Http\Controllers\Slotlayer;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests; 
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Specialtactics\L5Api\Http\Controllers\RestfulController as BaseController;
use Illuminate\Http\Request;
use Validator;
use Illuminate\Support\Facades\Http;
use App\Models\Slotlayer\Gameoptions;
use App\Models\Slotlayer\CreateSessionErrors;
use App\Models\Slotlayer\DemoSessions;
use App\Models\Slotlayer\RegularSessions;
use App\Models\Slotlayer\AccessProfiles;
use App\Models\Slotlayer\GameoptionsParent;
use \Cache;
use Carbon\Carbon;
use DB;
use Illuminate\Support\Facades\Log;
use Dingo\Api\Routing\Helpers;
use Dingo\Api\Http\Response;
use Illuminate\Support\Facades\Crypt;
use Webpatser\Uuid\Uuid;

class EvoplayController extends \App\Http\Controllers\Controller
{
    use Helpers;

    private $system_id = '1104';
    private $secret_key = '1f97708a839fe25ddbfdad9d329ac30e';
    private $version = '1';
    private $currency = 'USD';

    public function list()
    {
        $signature = $this->system_id.'*'.$this->version.'*'.$this->secret_key;
        $response = file_get_contents('http://api.production.games/Game/getList?project='.$this->system_id.'&version=1&signature='.md5($signature).'');
        return response($response)->header('Content-Type', 'application/json');
    }
    /**
     * @param $endpoint where callback URL & method is distributed
     * @return \Illuminate\Http\JsonResponse
     */
    public function endpoint(Request $request)
    {
        //Log::critical($request);
        if ($request->name === 'init') {
            return $this->balance($request);
        } elseif ($request->name === 'balance') {
            return $this->balance($request);
        } elseif ($request->name === 'bet') {
            return $this->bet($request);
        } elseif ($request->name === 'win') {
            return $this->bet($request);
        } else {
            return $this->balance($request);
        }
    }

    /**
     *     @param $create Slot Game
     */
    public static function createSlots($playerId, $game_id, $extra_id, $casino_id, $mode, $nativecurrency)
    {
        $evoexplode = explode('-', $playerId);
        $operatorevo = $casino_id;
        $unique = uniqid();
        $getevouid = $extra_id;
        $operatorUrl = 'https://rdev2.bets.sh';

        if($mode === 'demo') {
           $token = 'demo';
        } else {
           $token = $unique . '-' . $playerId . '@' . $game_id .'@'. $casino_id;
        }

        $gameevo = $getevouid;
        $args = [ 
            $token, 
            $gameevo, 
            [ 
                $playerId, 
                $operatorUrl, //exit_url 
                $operatorUrl, //cash_url
                '1' //https
            ], 
            '1', //denomination
            $nativecurrency, //currency
            '1', //return_url_info
            '2' //callback_version
        ]; 



        $signature = self::getSignature('1104', '1', $args, '1f97708a839fe25ddbfdad9d329ac30e');
        $url = 'http://api.production.games/Game/getURL?project=1104&version=1&signature='.$signature.'&token='.$token.'&game='.$gameevo.'&settings[user_id]='.$playerId.'&settings[exit_url]='.$operatorUrl.'&settings[cash_url]='.$operatorUrl.'&settings[https]=1&denomination=1&currency='.$nativecurrency.'&return_url_info=1&callback_version=2';
        $getResponse = Http::get($url);
        $response = json_decode($getResponse, true);

        $url = $response['data']['link'];
        header('Access-Control-Allow-Origin: *');
        header('Content-type: application/json');

        return array('url' => $url);
    }

    /**
     *     @param $get balance 
     */
    public function balance(Request $request)
    {
            $token = $request['token'];
            $currency = explode('-', $token);
            $currency = $currency[2];
            $currency = explode('@', $currency);
            $currency = $currency[0];
            $playerId = explode('-', $token);
            $playerId = $playerId[1];

            $getoperator = explode('@', $token);
            $getoperator = $getoperator[2];

            $baseurl = $findoperator->callbackurl;
            $prefix = $findoperator->slots_prefix;

            $url = 'https://rdev1.bets.sh/calls/aggregation/game/balance?currency='.$currency.'&playerid='.$playerId;
            Log::notice($url);
            $userdata = '';
            $jsonbody = json_encode($userdata);
            $curlcatalog = curl_init();
            curl_setopt_array($curlcatalog, array(
                CURLOPT_URL => $url,
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_ENCODING => '',
                CURLOPT_MAXREDIRS => 10,
                CURLOPT_TIMEOUT => 0,
                CURLOPT_POST => 1,
                CURLOPT_POSTFIELDS => $jsonbody,
                CURLOPT_FOLLOWLOCATION => true,
                CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
                CURLOPT_CUSTOMREQUEST => 'POST',
                CURLOPT_HTTPHEADER => array(
                "Content-Type: application/json"
          ),
        ));
        
        $responsecurl = curl_exec($curlcatalog);
        curl_close($curlcatalog);
        $responsecurl = json_decode($responsecurl, true);

        return response()->json([
                'status' => 'ok',
                'data' => ([
                    'balance' => round($responsecurl['result']['balance'] / 100, 2),
                    'currency' => $findoperator->native_currency    
                ])
            ]);

        }
    
    public function bet(Request $request)
    {
        $token = $request['token'];
        $explode = explode('-', $token);
        $explode = $explode[2];
        $currency = explode('@', $explode);
        $currency = $currency[0];
        $playerId = explode('-', $token);
        $playerId = $playerId[1];
        $gamedata = explode('@', $token);
        $gamedata = $gamedata[1];
        $gameid = $gamedata[1];
        $reqdata = $request['data'];

        if($request->name === 'win') {
        $bet = 0;
        $win = $reqdata['amount'];
        } else {
        $bet = $reqdata['amount'];
        $win = 0;
        }
        $roundingBet = $bet * 100;
        $roundingBet = (int)$roundingBet;
        $roundingWin = $win * 100;
        $roundingWin = (int)$roundingWin;

        $roundid = $reqdata['round_id'];
        $details = $reqdata['details'];


        $decodeddetails = json_decode($details);
        $finalaction = $reqdata['final_action'] ?? 0;
        $transactionid = $request['callback_id'] ?? 0;
        $bonusmode = $decodeddetails->game_mode_code ?? 0;
        $getoperator = explode('@', $token);
        $getoperator = $getoperator[2];
        $findoperator = Gameoptions::where('id', $getoperator)->first();

        $checkifExist = Gametransactions::where('txid', $transactionid)->where('player', $playerId)->first();

        if($checkifExist) {
                return response()->json([
                    'status' => 'error',
                    'error' => ([
                        'scope' => "user",
                        'no_refund' => "1",
                        'message' => "Not enough money"
                    ])
                ]);
        }

            $slug_type = $findoperator->slug_type;
            if($slug_type !== '0') {
                $gameList = \App\Models\Gamelist::where('game_id', $gamedata)->first();

                if($slug_type === '1') {
                    $gamedata = $gameList->game_slug ?? $gameList->game_id;
                }
                if($slug_type === '2') {
                    $gamedata = $gameList->softswiss ?? $gameList->game_id;
                }
            }
            
            $baseurl = $findoperator->callbackurl;
            $prefix = $findoperator->slots_prefix;

            $verifySign = md5($findoperator->apikey.'-'.$roundid.'-'.$findoperator->operator_secret);

                try {

                    $OperatorTransactions = Gametransactions::create(['casinoid' => $findoperator->id, 'currency' => $findoperator->native_currency, 'player' => $playerId, 'ownedBy' => $findoperator->ownedBy, 'bet' => $roundingBet, 'win' => $roundingWin, 'gameid' => $gamedata, 'txid' => $transactionid, 'roundid' => $roundid, 'type' => 'slots', 'rawdata' => '[]']);

                    $OperatorRaw = GametransactionsRaw::create(['casinoid' => $findoperator->id, 'player' => $playerId, 'ownedBy' => $findoperator->ownedBy, 'txid' => $transactionid, 'roundid' => $roundid, 'rawdata' => json_encode($request->all(), JSON_UNESCAPED_UNICODE)]);
                    if($roundingBet > 0 || $roundingWin > 0) {

                    $processGgr = Gametransactions::processGgr($gameid, $findoperator->id, $roundingWin, $roundingBet);
                
                    }       

                } catch (\Exception $exception) {
                    //Error trying to create operator transaction
                }


            if($finalaction === '1') {
            $totalTxs = Gametransactions::where('roundid', '=', $roundid)->where('player', '=', $playerId)->get();
            $totalWin = $totalTxs->sum('win');
            $totalBet = $totalTxs->sum('bet');

            $url = $baseurl.$prefix.'/bet?currency='.$currency.'&gameid='.$gamedata.'&roundid='.$roundid.'&playerid='.$playerId.'&bet='.$roundingBet.'&win='.$roundingWin.'&bonusmode='.$bonusmode.'&totalBet='.$totalBet.'&totalWin='.$totalWin.'&final='.$finalaction.'&sign='.$verifySign;

            } else {
                $url = $baseurl.$prefix.'/bet?currency='.$currency.'&gameid='.$gamedata.'&roundid='.$roundid.'&playerid='.$playerId.'&bet='.$roundingBet.'&win='.$roundingWin.'&bonusmode='.$bonusmode.'&final='.$finalaction.'&sign='.$verifySign;
            }


            if($findoperator->extendedApi === '1') {
            $userdata = array('sign' => $verifySign, "currency" => $currency, "gameid" => $gamedata, "roundid" => $roundid, "playerid" => $playerId, "bet" => "0", "win" => $rounding, "bonusmode" => $bonusmode, "final" => $finalaction);
            } else {
            $userdata = array('sign' => $verifySign, "roundid" => $roundid);
            }

                //Log::notice($url);
                $jsonbody = json_encode($userdata);
                $curlcatalog = curl_init();
                curl_setopt_array($curlcatalog, array(
                CURLOPT_URL => $url,
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_ENCODING => '',
                CURLOPT_MAXREDIRS => 10,
                CURLOPT_TIMEOUT => 0,
                CURLOPT_POST => 1,
                CURLOPT_POSTFIELDS => $jsonbody,
                CURLOPT_FOLLOWLOCATION => true,
                CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
                CURLOPT_CUSTOMREQUEST => 'POST',
                CURLOPT_HTTPHEADER => array(
                "Content-Type: application/json"
              ), ));
        $responsecurl = curl_exec($curlcatalog);
        curl_close($curlcatalog);
        //Log::critical($responsecurl);
        $responsecurl = json_decode($responsecurl, true);
                try {
                if($responsecurl['result']['balance']) {
                        return response()->json([
                            'status' => 'ok',
                            'data' => ([
                                'balance' => round($responsecurl['result']['balance'] / 100, 2),
                                'currency' => $findoperator->native_currency
                            ])
                        ]);
                    } 

                } catch (\Exception $exception) {
                return response()->json([
                    'status' => 'error',
                    'error' => ([
                        'scope' => "user",
                        'no_refund' => "1",
                        'message' => "Not enough money"
                    ])
                ]);
            }

        }

    public function win(Request $request)
    {
        $token = $request['token'];
        $explode = explode('-', $token);
        $explode = $explode[2];
        $currency = explode('@', $explode);
        $currency = $currency[0];
        
        $playerId = explode('-', $token);
        $playerId = $playerId[1];
        $gamedata = explode('@', $token);
        $gamedata = $gamedata[1];
        $reqdata = $request['data'];
        $amount = $reqdata['amount'];
        $roundid = $reqdata['round_id'];
        $details = $reqdata['details'];
        $decodeddetails = json_decode($details);
        $finalaction = 0;
        if($decodeddetails->final_action) {
        $finalaction = $decodeddetails->final_action ?? 0;
        }
        $getoperator = explode('@', $token);
        $getoperator = $getoperator[2];
        $findoperator = Gameoptions::where('id', $getoperator)->first();
    
            $baseurl = $findoperator->callbackurl;
            $prefix = $findoperator->slots_prefix;
            $rounding = $amount * 100;
            $rounding = (int)$rounding;
             try{
            
            if($rounding > 0) {
                $OperatorTransactions = Gametransactions::create(['casinoid' => $findoperator->id, 'currency' => $findoperator->native_currency, 'player' => $playerId, 'ownedBy' => $findoperator->ownedBy, 'bet' => '0', 'win' => $rounding, 'gameid' => $gamedata, 'txid' => $roundid, 'type' => 'slots', 'rawdata' => json_encode(['data' => $request->getContent()])]);
                if($rounding > 0) {
                $processGgr = Gametransactions::processGgr($gamedata, $findoperator->id, $roundingBet, '0');
                }
            }

            } catch (\Exception $exception) {
                //Error trying to create operator transaction
            }

            $verifySign = md5($findoperator->apikey.'-'.$roundid.'-'.$findoperator->operator_secret);
            $url = $baseurl.$prefix.'/bet?currency='.$currency.'&gameid='.$gamedata.'&roundid='.$roundid.'&playerid='.$playerId.'&sign='.$verifySign.'&bet=0&win='.$rounding.'&bonusmode='.$decodeddetails->game_mode_code.'&final='.$finalaction.'&sign='.$verifySign;
            if($findoperator->extendedApi === '1') {
            $userdata = array('sign' => $verifySign, "currency" => $currency, "gameid" => $gamedata, "roundid" => $roundid, "playerid" => $playerId, "bet" => "0", "win" => $rounding, "bonusmode" => $decodeddetails->game_mode_code, "final" => $finalaction);
            } else {
            $userdata = array('sign' => $verifySign, "roundid" => $roundid);
            }


            $jsonbody = json_encode($userdata);
            $curlcatalog = curl_init();
                curl_setopt_array($curlcatalog, array(
                    CURLOPT_URL => $url,
                    CURLOPT_RETURNTRANSFER => true,
                    CURLOPT_ENCODING => '',
                    CURLOPT_MAXREDIRS => 10,
                    CURLOPT_TIMEOUT => 0,
                    CURLOPT_POST => 1,
                    CURLOPT_POSTFIELDS => $jsonbody,
                    CURLOPT_FOLLOWLOCATION => true,
                    CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
                    CURLOPT_CUSTOMREQUEST => 'POST',
                    CURLOPT_HTTPHEADER => array(
                    "Content-Type: application/json"
              ),
         ));
        $responsecurl = curl_exec($curlcatalog);
        curl_close($curlcatalog);
        $responsecurl = json_decode($responsecurl, true);
        if($responsecurl['status'] == 'ok') {
        return response()->json([
            'status' => 'ok',
            'data' => ([
                'balance' => round($responsecurl['result']['balance'] / 100, 2),
                'currency' => $findoperator->native_currency    
            ])
        ]);  
    }

    }
    public static function getSignature($system_id, $version, array $args, $secret_key)
    {
        $md5 = array();
                $md5[] = $system_id;
                $md5[] = $version;
                foreach ($args as $required_arg) {
                        $arg = $required_arg;
                        if(is_array($arg)){
                                if(count($arg)) {
                                        $recursive_arg = '';
                                        array_walk_recursive($arg, function($item) use (& $recursive_arg) { if(!is_array($item)) { $recursive_arg .= ($item . ':');} });
                                        $md5[] = substr($recursive_arg, 0, strlen($recursive_arg)-1); // get rid of last colon-sign
                                } else {
                                $md5[] = '';
                                }
                        } else {
                $md5[] = $arg;
                }
        };
        $md5[] = $secret_key;
        $md5_str = implode('*', $md5);
        $md5 = md5($md5_str);
        return $md5;
    }


}
