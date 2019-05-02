use HTTP::Request::Common qw(POST); 
use LWP::UserAgent; 
$ua = LWP::UserAgent->new;
my $user   = $ARGV[0];
my $password = $ARGV[1];

my $req = POST 'https://uts-ws.nlm.nih.gov/restful/isValidUMLSUser', 
[ licenseCode => 'NLM-407569991', user =>$user,password=>$password];
print $req;

print $ua->request($req)->as_string;
